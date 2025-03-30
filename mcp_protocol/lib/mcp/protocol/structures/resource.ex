# codegen: do not edit
defmodule MCP.Protocol.Structures.Resource do
  @moduledoc """
  A known resource that the server is capable of reading.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:annotations, Annotations)
    field(:description, String.t())
    field(:mime_type, String.t())
    field(:name, String.t())
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"annotations", :annotations}) => MCP.Protocol.Structures.Annotations.schematic(),
      optional({"description", :description}) => str(),
      optional({"mimeType", :mime_type}) => str(),
      optional({"name", :name}) => str(),
      optional({"uri", :uri}) => str()
    })
  end
end
