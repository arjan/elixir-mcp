# codegen: do not edit
defmodule MCP.Protocol.Structures.JSONRPCRequest do
  @moduledoc """
  A request that expects a response.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:id, RequestId)
    field(:jsonrpc, String.t())
    field(:method, String.t())
    field(:params, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"id", :id}) => MCP.Protocol.Structures.RequestId.schematic(),
      optional({"jsonrpc", :jsonrpc}) => str(),
      optional({"method", :method}) => str(),
      optional({"params", :params}) => map()
    })
  end
end
