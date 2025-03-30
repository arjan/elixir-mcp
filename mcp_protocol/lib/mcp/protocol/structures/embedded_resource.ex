# codegen: do not edit
defmodule MCP.Protocol.Structures.EmbeddedResource do
  @moduledoc """
  The contents of a resource, embedded into a prompt or tool call result.

  It is up to the client how best to render embedded resources for the benefit
  of the LLM and/or the user.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:annotations, Annotations)
    field(:resource, map())
    field(:type, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"annotations", :annotations}) => MCP.Protocol.Structures.Annotations.schematic(),
      optional({"resource", :resource}) =>
        oneof([
          MCP.Protocol.Structures.TextResourceContents.schematic(),
          MCP.Protocol.Structures.BlobResourceContents.schematic()
        ]),
      optional({"type", :type}) => str()
    })
  end
end
