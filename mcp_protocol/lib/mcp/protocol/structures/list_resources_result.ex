# codegen: do not edit
defmodule MCP.Protocol.Structures.ListResourcesResult do
  @moduledoc """
  The server's response to a resources/list request from the client.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:next_cursor, String.t())
    field(:resources, list(Resource))
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"nextCursor", :next_cursor}) => str(),
      optional({"resources", :resources}) => list(MCP.Protocol.Structures.Resource.schematic())
    })
  end
end
