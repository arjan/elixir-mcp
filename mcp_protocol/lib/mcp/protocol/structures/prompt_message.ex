# codegen: do not edit
defmodule MCP.Protocol.Structures.PromptMessage do
  @moduledoc """
  Describes a message returned as part of a prompt.

  This is similar to `SamplingMessage`, but also supports the embedding of
  resources from the MCP server.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:content, map())
    field(:role, Role)
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"content", :content}) =>
        oneof([
          MCP.Protocol.Structures.TextContent.schematic(),
          MCP.Protocol.Structures.ImageContent.schematic(),
          MCP.Protocol.Structures.AudioContent.schematic(),
          MCP.Protocol.Structures.EmbeddedResource.schematic()
        ]),
      optional({"role", :role}) => MCP.Protocol.Structures.Role.schematic()
    })
  end
end
