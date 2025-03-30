# codegen: do not edit
defmodule MCP.Protocol.Structures.TextResourceContents do
  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:mime_type, String.t())
    field(:text, String.t())
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"mimeType", :mime_type}) => str(),
      optional({"text", :text}) => str(),
      optional({"uri", :uri}) => str()
    })
  end
end
