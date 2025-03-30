# codegen: do not edit
defmodule MCP.Protocol.Structures.JSONRPCResponse do
  @moduledoc """
  A successful (non-error) response to a request.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:id, RequestId)
    field(:jsonrpc, String.t())
    field(:result, Result)
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"id", :id}) => MCP.Protocol.Structures.RequestId.schematic(),
      optional({"jsonrpc", :jsonrpc}) => str(),
      optional({"result", :result}) => MCP.Protocol.Structures.Result.schematic()
    })
  end
end
