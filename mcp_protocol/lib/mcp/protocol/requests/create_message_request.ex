# codegen: do not edit
defmodule MCP.Protocol.Requests.CreateMessageRequest do
  @moduledoc """
  A request from the server to sample an LLM via the client. The client has full discretion over which model to select. The client should also inform the user before beginning sampling, to allow them to inspect the request (human in the loop) and decide whether to approve it.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:method, String.t(), default: "sampling/createMessage")
    field(:jsonrpc, String.t(), default: "2.0")
    field(:id, integer(), enforce: true)
    field(:params, MCP.Protocol.Structures.CreateMessageParams.t())
  end

  @type result :: MCP.Protocol.Structures.CreateMessageResult.t()

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      method: "sampling/createMessage",
      jsonrpc: "2.0",
      id: int(),
      params: MCP.Protocol.Structures.CreateMessageParams.schematic()
    })
  end

  @doc false
  @spec result() :: Schematic.t()
  def result() do
    oneof([
      MCP.Protocol.Structures.CreateMessageResult.schematic(),
      MCP.Protocol.ErrorResponse.schematic()
    ])
  end
end
