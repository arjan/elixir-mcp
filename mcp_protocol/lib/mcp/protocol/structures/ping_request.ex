# codegen: do not edit
defmodule MCP.Protocol.Structures.PingRequest do
  @moduledoc """
  A ping, issued by either the server or the client, to check that the other party is still alive. The receiver must promptly respond, or else may be disconnected.
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
