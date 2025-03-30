# codegen: do not edit
defmodule MCP.Protocol.Requests.GetPromptRequest do
  @moduledoc """
  Used by the client to get a prompt provided by the server.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "prompts/get")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.GetPromptParams.t())
  end

  @type result :: MCP.Protocol.Structures.Result.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "prompts/get",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.GetPromptParams.schematic()
    })
  end

  @doc false
  @spec result() :: Schematic.t()
  def result() do
    oneof([
      MCP.Protocol.Structures.Result.schematic(),
      MCP.Protocol.ErrorResponse.schematic()
    ])
  end
end
