# codegen: do not edit
defmodule MCP.Protocol.Structures.GetPromptResult do
  @moduledoc """
  The server's response to a prompts/get request from the client.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:description, String.t())
    field(:messages, list(PromptMessage))
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"description", :description}) => str(),
      optional({"messages", :messages}) => list(MCP.Protocol.Structures.PromptMessage.schematic())
    })
  end
end
