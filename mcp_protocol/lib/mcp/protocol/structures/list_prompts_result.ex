# codegen: do not edit
defmodule MCP.Protocol.Structures.ListPromptsResult do
  @moduledoc """
  The server's response to a prompts/list request from the client.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:next_cursor, String.t())
    field(:prompts, list(Prompt))
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"nextCursor", :next_cursor}) => str(),
      optional({"prompts", :prompts}) => list(MCP.Protocol.Structures.Prompt.schematic())
    })
  end
end
