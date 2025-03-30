# codegen: do not edit
defmodule MCP.Protocol.Notifications.InitializedNotification do
  @moduledoc """
  This notification is sent from the client to the server after initialization has finished.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "notifications/initialized")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:params, MCP.Protocol.Structures.InitializedParams.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "notifications/initialized",
      jsonrpc: "2.0",
      params: MCP.Protocol.Structures.InitializedParams.schematic()
    })
  end
end
