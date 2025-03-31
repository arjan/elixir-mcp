# codegen: do not edit
defmodule MCP.Protocol.Requests.ListPromptsRequest do
  @moduledoc """
  Sent from the client to request a list of prompts and prompt templates the server has.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "prompts/list")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.ListPromptsParams.t())
  end

  @type result :: MCP.Protocol.Structures.ListPromptsResult.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "prompts/list",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.ListPromptsParams.schematic()
    })
  end

  @doc false
  @spec result() :: Schematic.t()
  def result() do
    oneof([
      MCP.Protocol.Structures.ListPromptsResult.schematic(),
      MCP.Protocol.ErrorResponse.schematic()
    ])
  end
end
