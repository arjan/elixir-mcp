# codegen: do not edit
defmodule MCP.Protocol.Structures.RequestId do
  @moduledoc """
  A uniquely identifying ID for a request in JSON-RPC.
  """

  import Schematic, warn: false

  @type t :: String.t() | integer()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    oneof([str(), int()])
  end
end
