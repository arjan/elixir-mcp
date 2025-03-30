# codegen: do not edit
defmodule MCP.Protocol.Structures.ProgressParams do
  @moduledoc """
  Parameters for ProgressNotification
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:message, String.t())
    field(:progress, number())
    field(:progress_token, ProgressToken)
    field(:total, number())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"message", :message}) => str(),
      optional({"progress", :progress}) => int(),
      optional({"progressToken", :progress_token}) =>
        MCP.Protocol.Structures.ProgressToken.schematic(),
      optional({"total", :total}) => int()
    })
  end
end
