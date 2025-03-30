# codegen: do not edit
defmodule MCP.Protocol.Structures.Tool do
  @moduledoc """
  Definition for a tool the client can call.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:annotations, ToolAnnotations)
    field(:description, String.t())
    field(:input_schema, map())
    field(:name, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"annotations", :annotations}) =>
        MCP.Protocol.Structures.ToolAnnotations.schematic(),
      optional({"description", :description}) => str(),
      optional({"inputSchema", :input_schema}) => map(),
      optional({"name", :name}) => str()
    })
  end
end
