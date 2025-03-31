# codegen: do not edit
defmodule MCP.Protocol.Structures.ListToolsResult do
  @moduledoc """
  The server's response to a tools/list request from the client.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:next_cursor, String.t())
    field(:tools, list(Tool))
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"nextCursor", :next_cursor}) => str(),
      optional({"tools", :tools}) => list(MCP.Protocol.Structures.Tool.schematic())
    })
  end
end
