# codegen: do not edit
defmodule MCP.Protocol.Structures.Prompt do
  @moduledoc """
  A prompt or prompt template that the server offers.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:arguments, list(PromptArgument))
    field(:description, String.t())
    field(:name, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"arguments", :arguments}) =>
        list(MCP.Protocol.Structures.PromptArgument.schematic()),
      optional({"description", :description}) => str(),
      optional({"name", :name}) => str()
    })
  end
end
