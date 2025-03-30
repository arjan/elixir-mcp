# codegen: do not edit
defmodule MCP.Protocol.Structures.ResourceUpdatedNotification do
  @moduledoc """
  A notification from the server to the client, informing it that a resource has changed and may need to be read again. This should only be sent if the client previously sent a resources/subscribe request.
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
