defmodule MCP.ServerTest do
  use ExUnit.Case
  doctest MCP.Server

  defmodule TestServer do
    use MCP.Server

    def init(state, _args) do
      {:ok, state}
    end

    @decorate tool()
    @doc "This is a tool"
    @spec double_it(integer()) :: integer()
    def double_it(a) do
      a * 2
    end
  end

  alias MCP.Protocol.Structures.Tool

  test "MCP server exposes its info" do
    assert TestServer.__mcp__() == %{
             tools: [double_it: 1]
           }
  end

  test "MCP server exposes its tools" do
    assert MCP.Server.tools(TestServer) == [
             %Tool{
               annotations: %{},
               description: "This is a tool",
               input_schema: %{"type" => "integer", "description" => "a"},
               name: "double_it"
             }
           ]
  end
end
