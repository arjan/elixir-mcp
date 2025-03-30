# codegen: do not edit
defmodule MCP.Protocol.Structures.JSONRPCBatchResponse do
  @moduledoc """
  A JSON-RPC batch response, as described in https://www.jsonrpc.org/specification#batch.
  """

  import Schematic, warn: false

  @type t :: list()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    list()
  end
end
