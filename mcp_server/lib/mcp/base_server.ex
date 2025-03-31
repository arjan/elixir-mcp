defmodule MCP.BaseServer do
  alias MCP.Protocol.Structures.LoggingLevel
  alias MCP.Protocol.ErrorResponse
  alias MCP.Server.Buffer

  defmodule State do
    use TypedStruct

    @doc """
    The MCP data structure.
    """
    typedstruct do
      field(:mod, atom(), enforce: true)
      field(:assigns, map(), default: Map.new())
      field(:buffer, atom() | pid())
      field(:pid, pid())
    end

    @spec assign(t(), Keyword.t()) :: t()
    def assign(%__MODULE__{assigns: assigns} = state, new_assigns) when is_list(new_assigns) do
      %{state | assigns: Map.merge(assigns, Map.new(new_assigns))}
    end
  end

  defmodule InvalidRequest do
    defexception message: nil

    @impl true
    def exception({request, errors}) do
      msg = """
      Invalid request from the client

      Received: #{inspect(request)}
      Errors: #{inspect(errors)}
      """

      %__MODULE__{message: msg}
    end
  end

  defmodule InvalidResponse do
    defexception message: nil

    @impl true
    def exception({method, response, errors}) do
      msg = """
      Invalid response for request #{method}.

      Response: #{inspect(response)}
      Errors: #{inspect(errors)}
      """

      %__MODULE__{message: msg}
    end
  end

  defmodule InvalidNotification do
    defexception message: nil

    @impl true
    def exception({notification, errors}) do
      msg = """
      Invalid notification from the client

      Given: #{inspect(notification)}
      Errors: #{inspect(errors)}
      """

      %__MODULE__{message: msg}
    end
  end

  defmacro __using__(_) do
    quote do
      @behaviour MCP.BaseServer

      require Logger

      import MCP.BaseServer.State

      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :worker,
          restart: :permanent,
          shutdown: 500
        }
      end

      @impl true
      def handle_info(_, state) do
        # warning(state, "Unhandled message passed to handle_info/2")

        {:noreply, state}
      end

      defoverridable handle_info: 2
    end
  end

  require Logger

  @doc """
  The callback responsible for initializing the process.

  Receives the `t:MCP.BaseServer.State.t/0` token as the first argument and the arguments that were passed to `MCP.Server.start_link/3` as the second.

  ## Usage

  ```elixir
  @impl true
  def init(state, args) do
    some_arg = Keyword.fetch!(args, :some_arg)

    {:ok, assign(state, static_assign: :some_assign, some_arg: some_arg)}
  end
  ```
  """
  @callback init(state :: State.t(), init_arg :: term()) :: {:ok, State.t()}
  @doc """
  The callback responsible for handling requests from the client.

  Receives the request struct as the first argument and the MCP token `t:MCP.BaseServer.State.t/0` as the second.

  ## Usage

  ```elixir
  @impl true
  def handle_request(%Requests.InitializeRequest{}, state) do
  {:reply,
    %Structures.InitializeResult{
      protocol_version: "2024-11-05",
      capabilities: %Structures.ServerCapabilities{
        tools: %{}
      },
      server_info: %Structures.Implementation{
        name: "Elixir Example MCP Server",
        version: "0.1.0"
      }
    }, state}
  end
  ```
  """
  @callback handle_request(request :: term(), state) ::
              {:reply, reply :: term(), state} | {:noreply, state}
            when state: MCP.BaseServer.State.t()
  @doc """
  The callback responsible for handling notifications from the client.

  Receives the notification struct as the first argument and the MCP token `t:MCP.BaseServer.State.t/0` as the second.

  ## Usage

  ```elixir
  @impl true
  def handle_notification(%Initialized{}, lsp) do
    # handle the notification

    {:noreply, lsp}
  end
  ```
  """
  @callback handle_notification(notification :: term(), state) :: {:noreply, state}
            when state: State.t()
  @doc """
  The callback responsible for handling normal messages.

  Receives the message as the first argument and the MCP token `t:MCP.BaseServer.State.t/0` as the second.

  ## Usage

  ```elixir
  @impl true
  def handle_info(message, lsp) do
    # handle the message

    {:noreply, lsp}
  end
  ```
  """
  @callback handle_info(message :: any(), state) :: {:noreply, state} when state: State.t()

  @options_schema NimbleOptions.new!(
                    buffer: [
                      type: {:or, [:pid, :atom]},
                      doc: "The `t:pid/0` or name of the `Buffer` process."
                    ],
                    name: [
                      type: :atom,
                      doc:
                        "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                    ]
                  )

  @doc """
  Starts a MCP server process that is linked to the current process.

  ## Options

  #{NimbleOptions.docs(@options_schema)}
  """
  def start_link(module, init_args, opts) do
    opts = NimbleOptions.validate!(opts, @options_schema)

    :proc_lib.start_link(__MODULE__, :init, [
      {module, init_args, Keyword.take(opts, [:name, :buffer]), self()}
    ])
  end

  @doc false
  def init({module, init_args, opts, parent}) do
    me = self()
    buffer = opts[:buffer]
    state = %State{mod: module, pid: me, buffer: buffer}

    case module.init(state, init_args) do
      {:ok, %State{} = state} ->
        deb = :sys.debug_options([])
        if opts[:name], do: Process.register(self(), opts[:name])
        :proc_lib.init_ack(parent, {:ok, me})

        Buffer.listen(buffer, me)

        loop(state, parent, deb)
    end
  end

  @doc """
  Sends a request from the client to the MCP process.

  Generally used by the `MCP.Server.Communication.Adapter` implementation to forward messages from the buffer to the MCP process.

  You shouldn't need to use this to implement a language server.
  """
  @spec request_server(pid(), message) :: message when message: term()
  def request_server(pid, request) do
    from = self()
    message = {:request, from, request}
    send(pid, message)
  end

  @doc """
  Sends a notification from the client to the MCP process.

  Generally used by the `MCP.Server.Communication.Adapter` implementation to forward messages from the buffer to the MCP process.

  You shouldn't need to use this to implement a language server.
  """
  @spec notify_server(pid(), message) :: message when message: term()
  def notify_server(pid, notification) do
    from = self()
    send(pid, {:notification, from, notification})
  end

  @doc ~S'''
  Sends a notification to the client from the MCP process.

  ## Usage

  ```elixir
  MCP.Server.notify(state, %TextDocumentPublishDiagnostics{
    params: %PublishDiagnosticsParams{
      uri: "file://#{file}",
      diagnostics: diagnostics
    }
  })
  ```
  '''
  @spec notify(State.t(), notification :: any()) :: :ok
  def notify(%{buffer: buffer}, notification) do
    Logger.debug("sent notification server -> client #{notification.method}",
      method: notification.method
    )

    :telemetry.span([:gen_lsp, :notify, :server], %{}, fn ->
      result =
        Buffer.outgoing(
          buffer,
          dump!(notification.__struct__.schematic(), notification)
        )

      {result, %{method: notification.method}}
    end)
  end

  @doc ~S'''
  Sends a request to the client from the MCP process.

  ## Usage

  ```elixir
  MCP.Server.request(state, %ClientRegisterCapability{
    id: System.unique_integer([:positive]),
    params: params
  })
  ```
  '''
  @spec request(State.t(), request :: any(), timeout :: atom() | non_neg_integer()) :: any()
  def request(%{buffer: buffer}, request, timeout \\ :infinity) do
    Logger.debug("sent request server -> client #{request.method}",
      id: request.id,
      method: request.method
    )

    :telemetry.span([:mcp_server, :request, :server], %{}, fn ->
      result =
        Buffer.outgoing_sync(
          buffer,
          dump!(request.__struct__.schematic(), request),
          timeout
        )

      result = unify!(request.__struct__.result(), result)

      {result, %{id: request.id, method: request.method}}
    end)
  end

  defp write_debug(device, event, name) do
    IO.write(device, "#{inspect(name)} event = #{inspect(event)}\n")
  end

  defp loop(%State{} = state, parent, deb) do
    receive do
      {:system, from, request} ->
        :sys.handle_system_msg(request, from, parent, __MODULE__, deb, state)

      {:request, from, request} ->
        deb = :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:in, :request, from})

        start = System.system_time(:microsecond)
        :telemetry.execute([:gen_lsp, :request, :client, :start], %{})

        attempt(
          state,
          "Last message received: handle_request #{inspect(request)}",
          [:mcp_server, :request, :client],
          fn
            {:error, error} ->
              {:ok, output} =
                Schematic.dump(
                  ErrorResponse.schematic(),
                  %ErrorResponse{
                    # internal error
                    code: 500,
                    message: error
                  }
                )

              packet = %{
                "jsonrpc" => "2.0",
                "id" => Process.get(:request_id),
                "error" => output
              }

              deb =
                :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:out, :request, from})

              Buffer.outgoing(state.buffer, packet)
              loop(state, parent, deb)

            _ ->
              request = Map.put_new(request, "params", %{})

              case MCP.Protocol.Requests.new(request) do
                {:ok, %{id: id} = req} ->
                  Process.put(:request_id, id)

                  result =
                    :telemetry.span([:mcp_server, :handle_request], %{method: req.method}, fn ->
                      {state.mod.handle_request(req, state), %{}}
                    end)

                  case result do
                    {:reply, reply, %State{} = state} ->
                      response_key =
                        case reply do
                          %ErrorResponse{} -> "error"
                          _ -> "result"
                        end

                      # if result is valid, continue, if not, we return an internal error
                      {response_key, response} =
                        case Schematic.dump(req.__struct__.result(), reply) do
                          {:ok, output} ->
                            log(state, "result: #{inspect(output)}")
                            {response_key, output}

                          {:error, errors} ->
                            exception = InvalidResponse.exception({req.method, reply, errors})

                            {:ok, output} =
                              Schematic.dump(
                                ErrorResponse.schematic(),
                                %ErrorResponse{
                                  code: 500,
                                  message: Exception.format(:error, exception)
                                }
                              )

                            {"error", output}
                        end

                      packet = %{
                        "jsonrpc" => "2.0",
                        "id" => id,
                        response_key => response
                      }

                      deb =
                        :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:out, :request, from})

                      Buffer.outgoing(state.buffer, packet)

                      duration = System.system_time(:microsecond) - start

                      Logger.debug(
                        "handled request client -> server #{req.method} in #{format_time(duration)}",
                        id: req.id,
                        method: req.method
                      )

                      :telemetry.execute([:gen_lsp, :request, :client, :stop], %{
                        duration: duration
                      })

                      loop(state, parent, deb)

                    {:noreply, state} ->
                      duration = System.system_time(:microsecond) - start

                      Logger.debug(
                        "handled request client -> server #{req.method} in #{format_time(duration)}",
                        id: req.id,
                        method: req.method
                      )

                      :telemetry.execute([:gen_lsp, :request, :client, :stop], %{
                        duration: duration
                      })

                      loop(state, parent, deb)
                  end

                {:error, errors} ->
                  # the payload is not parseable at all, other than being valid JSON and having
                  # an `id` property to signal its a request
                  exception = InvalidRequest.exception({request, errors})

                  {:ok, output} =
                    Schematic.dump(
                      MCP.Protocol.ErrorResponse.schematic(),
                      %MCP.Protocol.ErrorResponse{
                        # invalid request
                        code: 400,
                        message: Exception.format(:error, exception)
                      }
                    )

                  packet = %{
                    "jsonrpc" => "2.0",
                    "id" => request["id"],
                    "error" => output
                  }

                  deb =
                    :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:out, :request, from})

                  Buffer.outgoing(state.buffer, packet)

                  loop(state, parent, deb)
              end
          end
        )

      {:notification, from, notification} ->
        deb = :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:in, :notification, from})
        start = System.system_time(:microsecond)
        :telemetry.execute([:gen_lsp, :notification, :client, :start], %{})

        attempt(
          state,
          "Last message received: handle_notification #{inspect(notification)}",
          [:mcp_server, :notification, :client],
          fn
            {:error, _} ->
              loop(state, parent, deb)

            _ ->
              notification = Map.put_new(notification, "params", %{})

              case MCP.Protocol.Notifications.new(notification) do
                {:ok, note} ->
                  result =
                    :telemetry.span(
                      [:mcp_server, :handle_notification],
                      %{method: note.method},
                      fn ->
                        {state.mod.handle_notification(note, state), %{}}
                      end
                    )

                  case result do
                    {:noreply, %State{} = state} ->
                      duration = System.system_time(:microsecond) - start

                      Logger.debug(
                        "handled notification client -> server #{note.method} in #{format_time(duration)}",
                        method: note.method
                      )

                      :telemetry.execute([:gen_lsp, :notification, :client, :stop], %{
                        duration: duration
                      })

                      loop(state, parent, deb)
                  end

                {:error, errors} ->
                  # the payload is not parseable at all, other than being valid JSON
                  exception = InvalidNotification.exception({notification, errors})
                  error(state, Exception.format(:error, exception))

                  deb =
                    :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:out, :request, from})

                  loop(state, parent, deb)
              end
          end
        )

      message ->
        deb = :sys.handle_debug(deb, &write_debug/3, __MODULE__, {:in, :info, message})
        start = System.system_time(:microsecond)
        :telemetry.execute([:mcp_server, :info, :start], %{})

        attempt(
          state,
          "Last message received: handle_info #{inspect(message)}",
          [:mcp_server, :info],
          fn
            {:error, _} ->
              loop(state, parent, deb)

            _ ->
              result =
                :telemetry.span([:mcp_server, :handle_info], %{}, fn ->
                  {state.mod.handle_info(message, state), %{}}
                end)

              case result do
                {:noreply, %State{} = state} ->
                  duration = System.system_time(:microsecond) - start
                  :telemetry.execute([:mcp_server, :info, :stop], %{duration: duration})
                  loop(state, parent, deb)
              end
          end
        )
    end
  end

  defp format_time(time) when time < 1000 do
    "#{time}µs"
  end

  defp format_time(time) do
    "#{System.convert_time_unit(time, :microsecond, :millisecond)}ms"
  end

  @spec attempt(State.t(), String.t(), list(atom()), (:try | {:error, String.t()} -> any())) ::
          no_return()
  defp attempt(state, message, prefix, callback) do
    callback.(:try)
  rescue
    e ->
      :telemetry.execute(prefix ++ [:exception], %{message: message})

      message = Exception.format(:error, e, __STACKTRACE__)
      error(state, message)

      callback.({:error, message})
  end

  defp dump!(schematic, structure) do
    {:ok, output} = Schematic.dump(schematic, structure)
    output
  end

  defp unify!(schematic, structure) do
    {:ok, output} = Schematic.unify(schematic, structure)
    output
  end

  @doc false
  def system_continue(parent, deb, state) do
    loop(state, parent, deb)
  end

  @doc false
  def system_terminate(reason, _parent, _deb, _chs) do
    exit(reason)
  end

  @doc false
  def system_get_state(state) do
    {:ok, state}
  end

  @doc false
  def system_replace_state(state_fun, state) do
    new_state = state_fun.(state)

    {:ok, new_state, new_state}
  end

  @doc """
  Send a `window/logMessage` error notification to the client.

  See `MCP.Protocol.Enumerations.MessageType.error/0`.

  ## Usage

  ```elixir
  MCP.Server.error(lsp, "Failed to compiled!")
  ```
  """
  @spec error(State.t(), String.t()) :: :ok
  def error(state, message) do
    log_message(state, LoggingLevel.error(), message)
  end

  @doc """
  Send a `window/logMessage` error notification to the client.

  See `MCP.Protocol.Enumerations.MessageType.warning/0`.

  ## Usage

  ```elixir
  MCP.Server.warning(state, "Variable `foo` is unused.")
  ```
  """
  @spec warning(State.t(), String.t()) :: :ok
  def warning(state, message) do
    log_message(state, LoggingLevel.warning(), message)
  end

  @doc """
  Send a `window/logMessage` info notification to the client.

  See `MCP.Protocol.Enumerations.MessageType.info/0`.

  ## Usage

  ```elixir
  MCP.Server.info(state, "Compilation complete!")
  ```
  """
  @spec info(State.t(), String.t()) :: :ok
  def info(state, message) do
    log_message(state, LoggingLevel.info(), message)
  end

  @doc """
  Send a `window/logMessage` log notification to the client.

  See `MCP.Protocol.Enumerations.MessageType.log/0`.

  ## Usage

  ```elixir
  MCP.Server.log(state, "Starting compilation.")
  ```
  """
  @spec log(State.t(), String.t()) :: :ok
  def log(state, message) do
    log_message(state, LoggingLevel.notice(), message)
  end

  defp log_message(state, level, message) do
    notify(state, %MCP.Protocol.Notifications.LoggingMessageNotification{
      params: %MCP.Protocol.Structures.LoggingMessageParams{
        level: level,
        data: message
      }
    })
  end
end
