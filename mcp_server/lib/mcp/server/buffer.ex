defmodule MCP.Server.Buffer do
  @moduledoc """
  The data buffer between the MCP process and the communication channel.
  """
  use GenServer

  require Logger

  @options_schema NimbleOptions.new!(
                    communication: [
                      type: :mod_arg,
                      default: {MCP.Server.Communication.Stdio, []},
                      doc:
                        "A `{module, args}` tuple, where `module` implements the `MCP.Server.Communication.Adapter` behaviour."
                    ],
                    name: [
                      type: :atom,
                      doc:
                        "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                    ]
                  )

  @doc """
  Starts a `MCP.Server.Buffer` process that is linked to the current process.

  ## Options

  #{NimbleOptions.docs(@options_schema)}
  """
  def start_link(opts) do
    opts = NimbleOptions.validate!(opts, @options_schema)
    GenServer.start_link(__MODULE__, opts, Keyword.take(opts, [:name]))
  end

  @doc false
  def listen(server, lsp) do
    GenServer.cast(server, {:listen, lsp})
  end

  @doc false
  def incoming(server, packet) do
    GenServer.cast(server, {:incoming, packet})
  end

  @doc false
  def outgoing(server, packet) do
    GenServer.cast(server, {:outgoing, packet})
  end

  @doc false
  def outgoing_sync(server, packet, timeout \\ :infinity) do
    GenServer.call(server, {:outgoing_sync, packet}, timeout)
  end

  @doc false
  def comm_state(server) do
    GenServer.call(server, :comm_state)
  end

  @doc false
  def init(opts) do
    {comm, comm_args} = opts[:communication]
    {:ok, comm_data} = comm.init(comm_args)

    {:ok, %{comm: comm, comm_data: comm_data, awaiting_response: Map.new()}}
  end

  @doc false
  def handle_call(:comm_state, _from, %{comm_data: comm_data} = state) do
    {:reply, comm_data, state}
  end

  def handle_call({:outgoing_sync, %{"id" => id} = packet}, from, state) do
    :telemetry.span([:gen_mcp, :buffer, :outgoing], %{kind: :sync}, fn ->
      :ok = state.comm.write(Jason.encode!(packet), state.comm_data)
      {:ok, %{}}
    end)

    {:noreply, %{state | awaiting_response: Map.put(state.awaiting_response, id, from)}}
  end

  @doc false
  def handle_cast({:incoming, packet}, %{lsp: lsp} = state) do
    state =
      :telemetry.span([:gen_mcp, :buffer, :incoming], %{}, fn ->
        state =
          case packet do
            %{"id" => id, "result" => result} when is_map_key(state.awaiting_response, id) ->
              {from, awaiting_response} = Map.pop(state.awaiting_response, id)
              GenServer.reply(from, result)

              %{state | awaiting_response: awaiting_response}

            %{"id" => _} = request ->
              MCP.BaseServer.request_server(lsp, request)
              state

            notification ->
              MCP.BaseServer.notify_server(lsp, notification)
              state
          end

        {state, %{}}
      end)

    {:noreply, state}
  end

  def handle_cast({:outgoing, packet}, state) do
    :telemetry.span([:gen_mcp, :buffer, :outgoing], %{kind: :async}, fn ->
      :ok = state.comm.write(packet, state.comm_data)
      {:ok, %{}}
    end)

    {:noreply, state}
  end

  def handle_cast({:listen, lsp}, state) do
    read(state.comm, state.comm_data)

    {:noreply, Map.put(state, :lsp, lsp)}
  end

  @doc false
  def handle_info({:update_comm_data, comm_data}, state) do
    {:noreply, %{state | comm_data: comm_data}}
  end

  defp read(comm, comm_data) do
    me = self()

    Task.start_link(fn ->
      {:ok, comm_data} = comm.listen(comm_data)
      send(me, {:update_comm_data, comm_data})

      Stream.resource(
        fn -> "" end,
        fn buffer ->
          case comm.read(comm_data, buffer) do
            :eof ->
              if Application.get_env(:gen_mcp, :exit_on_end, true) do
                System.stop()
              end

              {:halt, :ok}

            {:error, reason} ->
              {:halt, {:error, reason}}

            {:ok, body, buffer} ->
              incoming(me, body)

              {[body], buffer}
          end
        end,
        fn
          {:error, reason} ->
            IO.warn("Unable to read from device: #{inspect(reason)}")

          _ ->
            :ok
        end
      )
      |> Enum.to_list()
    end)
  end

  @doc false
  def log(message) do
    Logger.debug(message)
  end
end
