# codegen: do not edit
defmodule MCP.Protocol.Structures.InitializeResult do
  @moduledoc """
  After receiving an initialize request from the client, the server sends this response.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:meta, map())
    field(:capabilities, ServerCapabilities)
    field(:instructions, String.t())
    field(:protocol_version, String.t())
    field(:server_info, Implementation)
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"_meta", :meta}) => map(),
      optional({"capabilities", :capabilities}) =>
        MCP.Protocol.Structures.ServerCapabilities.schematic(),
      optional({"instructions", :instructions}) => str(),
      optional({"protocolVersion", :protocol_version}) => str(),
      optional({"serverInfo", :server_info}) => MCP.Protocol.Structures.Implementation.schematic()
    })
  end
end
