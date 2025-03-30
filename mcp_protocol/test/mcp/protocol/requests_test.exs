defmodule MCP.Protocol.RequestsTest do
  use ExUnit.Case
  doctest MCP.Protocol.Requests
  alias MCP.Protocol.Requests

  @json """
          {"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{"sampling":{},"roots":{"listChanged":true}},"clientInfo":{"name":"mcp-inspector","version":"0.7.0"}}}
        """
        |> Jason.decode!()

  test "initialize request" do
    assert {:ok, request} = Requests.new(@json)
    assert request.method == "initialize"
  end
end
