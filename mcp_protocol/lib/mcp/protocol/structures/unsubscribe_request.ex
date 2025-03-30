# codegen: do not edit
defmodule MCP.Protocol.Structures.UnsubscribeRequest do
  @moduledoc """
  Sent from the client to request cancellation of resources/updated notifications from the server. This should follow a previous resources/subscribe request.
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
