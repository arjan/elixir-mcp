# codegen: do not edit
defmodule MCP.Protocol.Structures.SetLevelParams do
  @moduledoc """
  Parameters for SetLevelRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:level, LoggingLevel)
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"level", :level}) => MCP.Protocol.Structures.LoggingLevel.schematic()
    })
  end
end
