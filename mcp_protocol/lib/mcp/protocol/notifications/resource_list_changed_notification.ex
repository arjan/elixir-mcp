# codegen: do not edit
defmodule MCP.Protocol.Notifications.ResourceListChangedNotification do
  @moduledoc """
  An optional notification from the server to the client, informing it that the list of resources it can read from has changed. This may be issued by servers without any previous subscription from the client.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/resources/list_changed")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.ResourceListChangedParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/resources/list_changed",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.ResourceListChangedParams.schematic()
    })
  end
end
