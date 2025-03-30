# codegen: do not edit
defmodule MCP.Protocol.Structures.JSONRPCNotification do
  @moduledoc """
  A notification which does not expect a response.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:jsonrpc, String.t())
    field(:method, String.t())
    field(:params, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"jsonrpc", :jsonrpc}) => str(),
      optional({"method", :method}) => str(),
      optional({"params", :params}) => map()
    })
  end
end
