# codegen: do not edit
defmodule MCP.Protocol.Structures.ReadResourceResult do
  @moduledoc """
  The server's response to a resources/read request from the client.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())

    field(
      :contents,
      list(
        MCP.Protocol.Structures.TextResourceContents.t()
        | MCP.Protocol.Structures.BlobResourceContents.t()
      )
    )
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"contents", :contents}) =>
        list(
          oneof([
            MCP.Protocol.Structures.TextResourceContents.schematic(),
            MCP.Protocol.Structures.BlobResourceContents.schematic()
          ])
        )
    })
  end
end
