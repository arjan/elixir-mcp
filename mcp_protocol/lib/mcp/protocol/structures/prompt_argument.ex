# codegen: do not edit
defmodule MCP.Protocol.Structures.PromptArgument do
  @moduledoc """
  Describes an argument that a prompt can accept.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:description, String.t())
    field(:name, String.t())
    field(:required, boolean())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"description", :description}) => str(),
      optional({"name", :name}) => str(),
      optional({"required", :required}) => bool()
    })
  end
end
