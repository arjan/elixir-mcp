# codegen: do not edit
defmodule MCP.Protocol.Structures.ResourceListChangedParams do
  @moduledoc """
  Parameters for ResourceListChangedNotification
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
