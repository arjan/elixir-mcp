# codegen: do not edit
defmodule MCP.Protocol.Requests do
  import Schematic

  def new(request) do
    unify(
      oneof(fn
        %{"method" => "initialize"} ->
          MCP.Protocol.Requests.InitializeRequest.schematic()

        %{"method" => "ping"} ->
          MCP.Protocol.Requests.PingRequest.schematic()

        %{"method" => "resources/list"} ->
          MCP.Protocol.Requests.ListResourcesRequest.schematic()

        %{"method" => "resources/read"} ->
          MCP.Protocol.Requests.ReadResourceRequest.schematic()

        %{"method" => "resources/subscribe"} ->
          MCP.Protocol.Requests.SubscribeRequest.schematic()

        %{"method" => "resources/unsubscribe"} ->
          MCP.Protocol.Requests.UnsubscribeRequest.schematic()

        %{"method" => "prompts/list"} ->
          MCP.Protocol.Requests.ListPromptsRequest.schematic()

        %{"method" => "prompts/get"} ->
          MCP.Protocol.Requests.GetPromptRequest.schematic()

        %{"method" => "tools/list"} ->
          MCP.Protocol.Requests.ListToolsRequest.schematic()

        %{"method" => "tools/call"} ->
          MCP.Protocol.Requests.CallToolRequest.schematic()

        %{"method" => "logging/setLevel"} ->
          MCP.Protocol.Requests.SetLevelRequest.schematic()

        %{"method" => "completion/complete"} ->
          MCP.Protocol.Requests.CompleteRequest.schematic()

        %{"method" => "sampling/createMessage"} ->
          MCP.Protocol.Requests.CreateMessageRequest.schematic()

        %{"method" => "roots/list"} ->
          MCP.Protocol.Requests.ListRootsRequest.schematic()

        _ ->
          {:error, "unexpected request payload"}
      end),
      request
    )
  end
end
