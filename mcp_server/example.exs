defmodule TestServer do
  use MCP.Server

  def start_link(args) do
    {args, opts} = Keyword.split(args, [])
    MCP.Server.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(state, _args) do
    Logger.info("Server started")
    {:ok, assign(state, documents: %{})}
  end

  def handle_request(message, state) do
    MCP.Server.log(state, "Received request: #{inspect(message)}")
    {:reply, %{message: "Hello, world!"}, state}
  end

  def handle_notification(message, state) do
    MCP.Server.log(state, "Received notification: #{inspect(message)}")
    {:noreply, state}
  end

  def handle_info(message, state) do
    IO.puts("Received message: #{inspect(message)}")
    {:noreply, state}
  end
end

Logger.configure(level: :warning)

{:ok, buffer} =
  GenServer.start(MCP.Server.Buffer, communication: {MCP.Server.Communication.Stdio, []})

Process.monitor(buffer)

{:ok, state} = TestServer.start_link(buffer: buffer)

Process.monitor(state)

receive do
  {:DOWN, _, _, _, _} ->
    IO.puts("MCP process down")
end
