# codegen: do not edit
defmodule MCP.Protocol.Structures.ClientCapabilities do
  @moduledoc """
  Capabilities a client may support. Known capabilities are defined here, in this schema, but this is not a closed set: any client can define its own, additional capabilities.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:experimental, map())
    field(:roots, map())
    field(:sampling, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"experimental", :experimental}) => map(),
      optional({"roots", :roots}) => map(),
      optional({"sampling", :sampling}) => map()
    })
  end
end
