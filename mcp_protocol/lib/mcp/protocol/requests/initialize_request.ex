# codegen: do not edit
defmodule MCP.Protocol.Requests.InitializeRequest do
  @moduledoc """
  This request is sent from the client to the server when it first connects, asking it to begin initialization.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "initialize")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.InitializeParams.t())
  end

  @type result :: MCP.Protocol.Structures.InitializeResult.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "initialize",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.InitializeParams.schematic()
    })
  end

  @doc false
  @spec result() :: Schematic.t()
  def result() do
    oneof([
      MCP.Protocol.Structures.InitializeResult.schematic(),
      MCP.Protocol.ErrorResponse.schematic()
    ])
  end
end
