# codegen: do not edit
defmodule MCP.Protocol.Notifications.ProgressNotification do
  @moduledoc """
  An out-of-band notification used to inform the receiver of a progress update for a long-running request.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/progress")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.ProgressParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/progress",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.ProgressParams.schematic()
    })
  end
end
