# codegen: do not edit
defmodule MCP.Protocol.Structures.ResourceContents do
  @moduledoc """
  The contents of a specific resource or sub-resource.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:mime_type, String.t())
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"mimeType", :mime_type}) => str(),
      optional({"uri", :uri}) => str()
    })
  end
end
