# codegen: do not edit
defmodule MCP.Protocol.Structures.RootsListChangedParams do
  @moduledoc """
  Parameters for RootsListChangedNotification
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map()
    })
  end
end
