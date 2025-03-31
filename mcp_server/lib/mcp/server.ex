defmodule MCP.Server do
  @moduledoc """
  A module that provides a simple way to create an MCP server.

  This module is a wrapper around the `MCP.BaseServer` module, providing a more
  idiomatic way to define an MCP server.
  """

  @callback init(state :: MCP.BaseServer.State.t(), args :: any()) ::
              {:ok, MCP.BaseServer.State.t()} | {:error, any()}

  defmacro __using__(opts) do
    opts_definitions = [
      name: [
        type: :string,
        default: "Elixir MCP server"
      ],
      version: [
        type: :string,
        default: "0.1.0"
      ]
    ]

    {:ok, opts} = NimbleOptions.validate(opts, opts_definitions)

    quote do
      use MCP.BaseServer
      use MCP.Server.Decorator

      Module.register_attribute(__MODULE__, :tools, accumulate: true)

      @before_compile MCP.Server.Compiler
      @behaviour MCP.Server

      def start_link(args) do
        {args, opts} = Keyword.split(args, [])
        MCP.BaseServer.start_link(__MODULE__, args, opts)
      end

      @impl true
      def init(state, _args) do
        {:ok, state}
      end

      defoverridable init: 2

      @impl MCP.BaseServer
      defdelegate handle_request(request, state), to: MCP.Server

      @impl true
      defdelegate handle_notification(notification, state), to: MCP.Server
    end
  end

  alias MCP.Protocol.Requests
  alias MCP.Protocol.Structures

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

  def handle_request(%Requests.PingRequest{}, state) do
    {:reply, %Structures.Result{}, state}
  end

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
    MCP.BaseServer.log(state, "Received request: #{inspect(message)}")

    {:reply,
     %MCP.Protocol.ErrorResponse{code: 500, message: "Not implemented: #{message.__struct__}"},
     state}
  end

  def handle_notification(message, state) do
    MCP.BaseServer.log(state, "Received notification: #{inspect(message)}")
    {:noreply, state}
  end
end
