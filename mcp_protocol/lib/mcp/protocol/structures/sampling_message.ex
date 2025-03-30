# codegen: do not edit
defmodule MCP.Protocol.Structures.SamplingMessage do
  @moduledoc """
  Describes a message issued to or received from an LLM API.
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
          MCP.Protocol.Structures.AudioContent.schematic()
        ]),
      optional({"role", :role}) => MCP.Protocol.Structures.Role.schematic()
    })
  end
end
