# codegen: do not edit
defmodule MCP.Protocol.Structures.Annotations do
  @moduledoc """
  Optional annotations for the client. The client can use annotations to inform how objects are used or displayed
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:audience, list(Role))
    field(:priority, number())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"audience", :audience}) => list(MCP.Protocol.Structures.Role.schematic()),
      optional({"priority", :priority}) => int()
    })
  end
end
