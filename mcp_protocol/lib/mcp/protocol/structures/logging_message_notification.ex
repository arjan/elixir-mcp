# codegen: do not edit
defmodule MCP.Protocol.Structures.LoggingMessageNotification do
  @moduledoc """
  Notification of a log message passed from server to client. If no logging/setLevel request has been sent from the client, the server MAY decide which messages to send automatically.
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
