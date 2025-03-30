# codegen: do not edit
defmodule MCP.Protocol.Structures.JSONRPCError do
  @moduledoc """
  A response to a request that indicates an error occurred.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:error, map())
    field(:id, RequestId)
    field(:jsonrpc, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"error", :error}) => map(),
      optional({"id", :id}) => MCP.Protocol.Structures.RequestId.schematic(),
      optional({"jsonrpc", :jsonrpc}) => str()
    })
  end
end
