# codegen: do not edit
defmodule MCP.Protocol.Structures.ListResourceTemplatesRequest do
  @moduledoc """
  Sent from the client to request a list of resource templates the server has.
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
