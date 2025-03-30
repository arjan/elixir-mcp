# codegen: do not edit
defmodule MCP.Protocol.Structures.Root do
  @moduledoc """
  Represents a root directory or file that the server can operate on.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:name, String.t())
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"name", :name}) => str(),
      optional({"uri", :uri}) => str()
    })
  end
end
