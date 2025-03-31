# codegen: do not edit
defmodule MCP.Protocol.Requests.ListRootsRequest do
  @moduledoc """
  Sent from the server to request a list of root URIs from the client. Roots allow
  servers to ask for specific directories or files to operate on. A common example
  for roots is providing a set of repositories or directories a server should operate
  on.

  This request is typically used when the server needs to understand the file system
  structure or access specific locations that the client has permission to read from.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "roots/list")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.ListRootsParams.t())
  end

  @type result :: MCP.Protocol.Structures.ListRootsResult.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "roots/list",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.ListRootsParams.schematic()
    })
  end

  @doc false
  @spec result() :: Schematic.t()
  def result() do
    oneof([
      MCP.Protocol.Structures.ListRootsResult.schematic(),
      MCP.Protocol.ErrorResponse.schematic()
    ])
  end
end
