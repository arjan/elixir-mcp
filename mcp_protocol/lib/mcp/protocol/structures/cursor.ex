# codegen: do not edit
defmodule MCP.Protocol.Structures.Cursor do
  @moduledoc """
  An opaque token used to represent a cursor for pagination.
  """

  import Schematic, warn: false

  @type t :: String.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    str()
  end
end
