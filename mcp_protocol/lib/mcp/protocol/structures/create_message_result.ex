# codegen: do not edit
defmodule MCP.Protocol.Structures.CreateMessageResult do
  @moduledoc """
  The client's response to a sampling/create_message request from the server. The client should inform the user before returning the sampled message, to allow them to inspect the response (human in the loop) and decide whether to allow the server to see it.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:content, map())
    field(:model, String.t())
    field(:role, Role)
    field(:stop_reason, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"content", :content}) =>
        oneof([
          MCP.Protocol.Structures.TextContent.schematic(),
          MCP.Protocol.Structures.ImageContent.schematic(),
          MCP.Protocol.Structures.AudioContent.schematic()
        ]),
      optional({"model", :model}) => str(),
      optional({"role", :role}) => MCP.Protocol.Structures.Role.schematic(),
      optional({"stopReason", :stop_reason}) => str()
    })
  end
end
