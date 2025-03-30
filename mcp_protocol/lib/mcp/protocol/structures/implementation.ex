# codegen: do not edit
defmodule MCP.Protocol.Structures.Implementation do
  @moduledoc """
  Describes the name and version of an MCP implementation.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:name, String.t())
    field(:version, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"name", :name}) => str(),
      optional({"version", :version}) => str()
    })
  end
end
