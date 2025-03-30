# codegen: do not edit
defmodule MCP.Protocol.Notifications.CancelledNotification do
  @moduledoc """
  This notification can be sent by either side to indicate that it is cancelling a previously-issued request.

  The request SHOULD still be in-flight, but due to communication latency, it is always possible that this notification MAY arrive after the request has already finished.

  This notification indicates that the result will be unused, so any associated processing SHOULD cease.

  A client MUST NOT attempt to cancel its `initialize` request.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/cancelled")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.CancelledParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/cancelled",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.CancelledParams.schematic()
    })
  end
end
