# codegen: do not edit
defmodule MCP.Protocol.Structures.TextContent do
  @moduledoc """
  Text provided to or from an LLM.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:annotations, Annotations)
    field(:text, String.t())
    field(:type, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"annotations", :annotations}) => MCP.Protocol.Structures.Annotations.schematic(),
      optional({"text", :text}) => str(),
      optional({"type", :type}) => str()
    })
  end
end
