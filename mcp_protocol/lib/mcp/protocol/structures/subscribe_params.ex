# codegen: do not edit
defmodule MCP.Protocol.Structures.SubscribeParams do
  @moduledoc """
  Parameters for SubscribeRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:uri, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"uri", :uri}) => str()
    })
  end
end
