# codegen: do not edit
defmodule MCP.Protocol.Structures.CreateMessageParams do
  @moduledoc """
  Parameters for CreateMessageRequest
  """

  import Schematic, warn: false

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field(:include_context, String.t())
    field(:max_tokens, integer())
    field(:messages, list(SamplingMessage))
    field(:metadata, map())
    field(:model_preferences, ModelPreferences)
    field(:stop_sequences, list(String.t()))
    field(:system_prompt, String.t())
    field(:temperature, number())
  end

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    schema(__MODULE__, %{
      optional({"includeContext", :include_context}) => str(),
      optional({"maxTokens", :max_tokens}) => int(),
      optional({"messages", :messages}) =>
        list(MCP.Protocol.Structures.SamplingMessage.schematic()),
      optional({"metadata", :metadata}) => map(),
      optional({"modelPreferences", :model_preferences}) =>
        MCP.Protocol.Structures.ModelPreferences.schematic(),
      optional({"stopSequences", :stop_sequences}) => list(str()),
      optional({"systemPrompt", :system_prompt}) => str(),
      optional({"temperature", :temperature}) => int()
    })
  end
end
