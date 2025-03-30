# codegen: do not edit
defmodule MCP.Protocol.Structures.InitializeParams do
  @moduledoc """
  Parameters for InitializeRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:capabilities, ClientCapabilities)
    field(:client_info, Implementation)
    field(:protocol_version, String.t())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"capabilities", :capabilities}) =>
        MCP.Protocol.Structures.ClientCapabilities.schematic(),
      optional({"clientInfo", :client_info}) =>
        MCP.Protocol.Structures.Implementation.schematic(),
      optional({"protocolVersion", :protocol_version}) => str()
    })
  end
end
