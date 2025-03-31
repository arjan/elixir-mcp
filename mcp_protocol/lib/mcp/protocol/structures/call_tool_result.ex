# codegen: do not edit
defmodule MCP.Protocol.Structures.CallToolResult do
  @moduledoc """
  The server's response to a tool call.

  Any errors that originate from the tool SHOULD be reported inside the result
  object, with `isError` set to true, _not_ as an MCP protocol-level error
  response. Otherwise, the LLM would not be able to see that an error occurred
  and self-correct.

  However, any errors in _finding_ the tool, an error indicating that the
  server does not support tool calls, or any other exceptional conditions,
  should be reported as an MCP error response.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())

    field(
      :content,
      list(
        MCP.Protocol.Structures.TextContent.t()
        | MCP.Protocol.Structures.ImageContent.t()
        | MCP.Protocol.Structures.AudioContent.t()
        | MCP.Protocol.Structures.EmbeddedResource.t()
      )
    )

    field(:is_error, boolean())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"content", :content}) =>
        list(
          oneof([
            MCP.Protocol.Structures.TextContent.schematic(),
            MCP.Protocol.Structures.ImageContent.schematic(),
            MCP.Protocol.Structures.AudioContent.schematic(),
            MCP.Protocol.Structures.EmbeddedResource.schematic()
          ])
        ),
      optional({"isError", :is_error}) => bool()
    })
  end
end
