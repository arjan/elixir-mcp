defmodule MCP.ServerTest do
  use ExUnit.Case
  doctest MCP.Server

  test "greets the world" do
    assert MCP.Server.hello() == :world
  end
end
