# codegen: do not edit
defmodule MCP.Protocol.Structures.Role do
  @type t :: String.t()

  import Schematic, warn: false

  @spec assistant() :: String.t()
  def assistant, do: "assistant"

  @spec user() :: String.t()
  def user, do: "user"

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    oneof([
      "assistant",
      "user"
    ])
  end
end
