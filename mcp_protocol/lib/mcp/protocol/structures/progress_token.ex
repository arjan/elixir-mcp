# codegen: do not edit
defmodule MCP.Protocol.Structures.ProgressToken do
  @moduledoc """
  A progress token, used to associate progress notifications with the original request.
  """

  import Schematic, warn: false

  @type t :: String.t() | integer()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    oneof([str(), int()])
  end
end
