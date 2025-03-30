# codegen: do not edit
defmodule MCP.Protocol.Structures.GetPromptParams do
  @moduledoc """
  Parameters for GetPromptRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:arguments, map())
    field(:name, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"arguments", :arguments}) => map(),
      optional({"name", :name}) => str()
    })
  end
end
