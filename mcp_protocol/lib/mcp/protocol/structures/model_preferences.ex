# codegen: do not edit
defmodule MCP.Protocol.Structures.ModelPreferences do
  @moduledoc """
  The server's preferences for model selection, requested of the client during sampling.

  Because LLMs can vary along multiple dimensions, choosing the "best" model is
  rarely straightforward.  Different models excel in different areas—some are
  faster but less capable, others are more capable but more expensive, and so
  on. This interface allows servers to express their priorities across multiple
  dimensions to help clients make an appropriate selection for their use case.

  These preferences are always advisory. The client MAY ignore them. It is also
  up to the client to decide how to interpret these preferences and how to
  balance them against other considerations.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:cost_priority, number())
    field(:hints, list())
    field(:intelligence_priority, number())
    field(:speed_priority, number())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"costPriority", :cost_priority}) => int(),
      optional({"hints", :hints}) => list(),
      optional({"intelligencePriority", :intelligence_priority}) => int(),
      optional({"speedPriority", :speed_priority}) => int()
    })
  end
end
