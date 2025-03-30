# codegen: do not edit
defmodule MCP.Protocol.Structures.LoggingMessageParams do
  @moduledoc """
  Parameters for LoggingMessageNotification
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:data, any)
    field(:level, LoggingLevel)
    field(:logger, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"data", :data}) => any(),
      optional({"level", :level}) => MCP.Protocol.Structures.LoggingLevel.schematic(),
      optional({"logger", :logger}) => str()
    })
  end
end
