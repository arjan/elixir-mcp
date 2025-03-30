# codegen: do not edit
defmodule MCP.Protocol.Structures.InitializeRequest do
  @moduledoc """
  This request is sent from the client to the server when it first connects, asking it to begin initialization.
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
