# codegen: do not edit
defmodule MCP.Protocol.Structures.RootsListChangedNotification do
  @moduledoc """
  A notification from the client to the server, informing it that the list of roots has changed.
  This notification should be sent whenever the client adds, removes, or modifies any root.
  The server should then request an updated list of roots using the ListRootsRequest.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t())
    field(:params, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"method", :method}) => str(),
      optional({"params", :params}) => map()
    })
  end
end
