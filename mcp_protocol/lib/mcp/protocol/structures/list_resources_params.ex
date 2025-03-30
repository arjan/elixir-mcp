# codegen: do not edit
defmodule MCP.Protocol.Structures.ListResourcesParams do
  @moduledoc """
  Parameters for ListResourcesRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:cursor, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"cursor", :cursor}) => str()
    })
  end
end
