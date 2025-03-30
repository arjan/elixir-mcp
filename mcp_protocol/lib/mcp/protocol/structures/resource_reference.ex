# codegen: do not edit
defmodule MCP.Protocol.Structures.ResourceReference do
  @moduledoc """
  A reference to a resource or resource template definition.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:type, String.t())
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"type", :type}) => str(),
      optional({"uri", :uri}) => str()
    })
  end
end
