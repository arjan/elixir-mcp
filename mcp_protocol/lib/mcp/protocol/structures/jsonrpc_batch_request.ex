# codegen: do not edit
defmodule MCP.Protocol.Structures.JSONRPCBatchRequest do
  @moduledoc """
  A JSON-RPC batch request, as described in https://www.jsonrpc.org/specification#batch.
  """

  import Schematic, warn: false

  @type t :: list()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    list()
  end
end
