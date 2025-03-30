# codegen: do not edit
defmodule MCP.Protocol.Structures.ToolAnnotations do
  @moduledoc """
  Additional properties describing a Tool to clients.

  NOTE: all properties in ToolAnnotations are **hints**. 
  They are not guaranteed to provide a faithful description of 
  tool behavior (including descriptive properties like `title`).

  Clients should never make tool use decisions based on ToolAnnotations
  received from untrusted servers.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:destructive_hint, boolean())
    field(:idempotent_hint, boolean())
    field(:open_world_hint, boolean())
    field(:read_only_hint, boolean())
    field(:title, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"destructiveHint", :destructive_hint}) => bool(),
      optional({"idempotentHint", :idempotent_hint}) => bool(),
      optional({"openWorldHint", :open_world_hint}) => bool(),
      optional({"readOnlyHint", :read_only_hint}) => bool(),
      optional({"title", :title}) => str()
    })
  end
end
