# codegen: do not edit
defmodule MCP.Protocol.Structures.CancelledParams do
  @moduledoc """
  Parameters for CancelledNotification
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:reason, String.t())
    field(:request_id, RequestId)
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"reason", :reason}) => str(),
      optional({"requestId", :request_id}) => MCP.Protocol.Structures.RequestId.schematic()
    })
  end
end
