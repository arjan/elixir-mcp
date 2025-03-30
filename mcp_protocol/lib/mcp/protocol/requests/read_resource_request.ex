# codegen: do not edit
defmodule MCP.Protocol.Requests.ReadResourceRequest do
  @moduledoc """
  Sent from the client to the server, to read a specific resource URI.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "resources/read")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.ReadResourceParams.t())
  end

  @type result :: MCP.Protocol.Structures.Result.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "resources/read",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.ReadResourceParams.schematic()
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
