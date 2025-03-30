# codegen: do not edit
defmodule MCP.Protocol.Structures.BlobResourceContents do
  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:blob, String.t())
    field(:mime_type, String.t())
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"blob", :blob}) => str(),
      optional({"mimeType", :mime_type}) => str(),
      optional({"uri", :uri}) => str()
    })
  end
end
