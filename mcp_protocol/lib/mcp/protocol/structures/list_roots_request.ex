# codegen: do not edit
defmodule MCP.Protocol.Structures.ListRootsRequest do
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
    field(:method, String.t())
    field(:params, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"method", :method}) => str(),
      optional({"params", :params}) => map()
    })
  end
end
