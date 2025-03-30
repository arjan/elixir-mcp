# codegen: do not edit
defmodule MCP.Protocol.Requests.SetLevelRequest do
  @moduledoc """
  A request from the client to the server, to enable or adjust logging.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "logging/setLevel")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.SetLevelParams.t())
  end

  @type result :: MCP.Protocol.Structures.Result.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "logging/setLevel",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.SetLevelParams.schematic()
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
