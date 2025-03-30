# codegen: do not edit
defmodule MCP.Protocol.Structures.ServerCapabilities do
  @moduledoc """
  Capabilities that a server may support. Known capabilities are defined here, in this schema, but this is not a closed set: any server can define its own, additional capabilities.
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:completions, map())
    field(:experimental, map())
    field(:logging, map())
    field(:prompts, map())
    field(:resources, map())
    field(:tools, map())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"completions", :completions}) => map(),
      optional({"experimental", :experimental}) => map(),
      optional({"logging", :logging}) => map(),
      optional({"prompts", :prompts}) => map(),
      optional({"resources", :resources}) => map(),
      optional({"tools", :tools}) => map()
    })
  end
end
