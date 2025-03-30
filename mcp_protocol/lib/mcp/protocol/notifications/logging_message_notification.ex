# codegen: do not edit
defmodule MCP.Protocol.Notifications.LoggingMessageNotification do
  @moduledoc """
  Notification of a log message passed from server to client. If no logging/setLevel request has been sent from the client, the server MAY decide which messages to send automatically.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/message")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.LoggingMessageParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/message",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.LoggingMessageParams.schematic()
    })
  end
end
