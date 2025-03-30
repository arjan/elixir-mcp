# codegen: do not edit
defmodule MCP.Protocol.Structures.CompleteParams do
  @moduledoc """
  Parameters for CompleteRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:argument, map())
    field(:ref, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"argument", :argument}) => map(),
      optional({"ref", :ref}) =>
        oneof([
          MCP.Protocol.Structures.PromptReference.schematic(),
          MCP.Protocol.Structures.ResourceReference.schematic()
        ])
    })
  end
end
