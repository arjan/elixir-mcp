# codegen: do not edit
defmodule MCP.Protocol.Structures.AudioContent do
  @moduledoc """
  Audio provided to or from an LLM.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:annotations, Annotations)
    field(:data, String.t())
    field(:mime_type, String.t())
    field(:type, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"annotations", :annotations}) => MCP.Protocol.Structures.Annotations.schematic(),
      optional({"data", :data}) => str(),
      optional({"mimeType", :mime_type}) => str(),
      optional({"type", :type}) => str()
    })
  end
end
