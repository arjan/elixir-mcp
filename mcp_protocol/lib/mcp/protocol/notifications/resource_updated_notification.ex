# codegen: do not edit
defmodule MCP.Protocol.Notifications.ResourceUpdatedNotification do
  @moduledoc """
  A notification from the server to the client, informing it that a resource has changed and may need to be read again. This should only be sent if the client previously sent a resources/subscribe request.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/resources/updated")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.ResourceUpdatedParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/resources/updated",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.ResourceUpdatedParams.schematic()
    })
  end
end
