# codegen: do not edit
defmodule MCP.Protocol.Structures.PaginatedResult do
  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:next_cursor, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"nextCursor", :next_cursor}) => str()
    })
  end
end
