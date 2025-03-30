# codegen: do not edit
defmodule MCP.Protocol.Notifications.RootsListChangedNotification do
  @moduledoc """
  A notification from the client to the server, informing it that the list of roots has changed.
  This notification should be sent whenever the client adds, removes, or modifies any root.
  The server should then request an updated list of roots using the ListRootsRequest.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/roots/list_changed")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.RootsListChangedParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/roots/list_changed",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.RootsListChangedParams.schematic()
    })
  end
end
