# codegen: do not edit
defmodule MCP.Protocol.Structures.ListPromptsParams do
  @moduledoc """
  Parameters for ListPromptsRequest
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
