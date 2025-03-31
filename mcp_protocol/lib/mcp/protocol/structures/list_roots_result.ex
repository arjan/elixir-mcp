# codegen: do not edit
defmodule MCP.Protocol.Structures.ListRootsResult do
  @moduledoc """
  The client's response to a roots/list request from the server.
  This result contains an array of Root objects, each representing a root directory
  or file that the server can operate on.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:roots, list(Root))
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"roots", :roots}) => list(MCP.Protocol.Structures.Root.schematic())
    })
  end
end
