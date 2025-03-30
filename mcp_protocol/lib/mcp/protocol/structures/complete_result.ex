# codegen: do not edit
defmodule MCP.Protocol.Structures.CompleteResult do
  @moduledoc """
  The server's response to a completion/complete request
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:completion, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"completion", :completion}) => map()
    })
  end
end
