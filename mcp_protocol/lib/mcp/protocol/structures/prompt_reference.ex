# codegen: do not edit
defmodule MCP.Protocol.Structures.PromptReference do
  @moduledoc """
  Identifies a prompt.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:name, String.t())
    field(:type, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"name", :name}) => str(),
      optional({"type", :type}) => str()
    })
  end
end
