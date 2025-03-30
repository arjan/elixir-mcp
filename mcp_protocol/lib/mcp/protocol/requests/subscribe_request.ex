# codegen: do not edit
defmodule MCP.Protocol.Requests.SubscribeRequest do
  @moduledoc """
  Sent from the client to request resources/updated notifications from the server whenever a particular resource changes.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "resources/subscribe")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.SubscribeParams.t())
  end

  @type result :: MCP.Protocol.Structures.Result.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "resources/subscribe",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.SubscribeParams.schematic()
    })
  end

  @doc false
  @spec result() :: Schematic.t()
  def result() do
    oneof([
      MCP.Protocol.Structures.Result.schematic(),
      MCP.Protocol.ErrorResponse.schematic()
    ])
  end
end
