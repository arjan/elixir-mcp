defmodule TestServer do
  @moduledoc """
  A simple example of an MCP server using the `MCP.BaseServer` module.

  Implementing MCP.BaseServer allows you to have fine grained control over the MCP
  server and its responses to the client, without any Elixir macro magic.

  The downside to this of course is that every MCP messages has to be handled by the module,
  and all the message structures must match with what is to be expected.

  For a simpler approach to building MCP servers, see the MCP.Server module which builds on
  BaseServer but allows for easier, more idiomatic MCP server implementation.
  """

  use MCP.BaseServer

  alias MCP.Protocol.Requests
  alias MCP.Protocol.Structures

  def start_link(args) do
    {args, opts} = Keyword.split(args, [])
    MCP.BaseServer.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(state, _args) do
    Logger.info("Server started")
    {:ok, assign(state, documents: %{})}
  end

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

  @impl true
  def handle_request(%Requests.PingRequest{}, state) do
    {:reply, %Structures.Result{}, state}
  end

  @impl true
  def handle_request(%Requests.ListToolsRequest{}, state) do
    {:reply,
     %Structures.ListToolsResult{
       tools: [
         %Structures.Tool{
           name: "example_tool",
           description: "Example tool",
           input_schema: %{
             type: "object",
             properties: %{
               name: %{type: "string"}
             },
             required: ["name"]
           }
         }
       ],
       next_cursor: nil
     }, state}
  end

  def handle_request(message, state) do
    MCP.Server.log(state, "Received request: #{inspect(message)}")

    {:reply,
     %MCP.Protocol.ErrorResponse{code: 500, message: "Not implemented: #{message.__struct__}"},
     state}
  end

  @impl true
  def handle_notification(message, state) do
    MCP.Server.log(state, "Received notification: #{inspect(message)}")
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
