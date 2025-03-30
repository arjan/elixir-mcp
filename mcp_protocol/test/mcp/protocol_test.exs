defmodule MCP.ProtocolTest do
  use ExUnit.Case
  doctest MCP.Protocol

  test "greets the world" do
    assert MCP.Protocol.hello() == :world
  end
end
