# codegen: do not edit
defmodule MCP.Protocol.Structures.ModelHint do
  @moduledoc """
  Hints to use for model selection.

  Keys not declared here are currently left unspecified by the spec and are up
  to the client to interpret.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:name, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"name", :name}) => str()
    })
  end
end
