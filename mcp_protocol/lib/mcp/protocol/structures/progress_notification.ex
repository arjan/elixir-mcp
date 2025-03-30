# codegen: do not edit
defmodule MCP.Protocol.Structures.ProgressNotification do
  @moduledoc """
  An out-of-band notification used to inform the receiver of a progress update for a long-running request.
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
