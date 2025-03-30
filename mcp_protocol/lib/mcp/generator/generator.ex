defmodule MCP.Protocol.Generator do
  @moduledoc """
  Protocol message generator for Model Context Protocol.

  takes the input JSON from the github repository, and generates
  requests (with their responses), notifications and structures from them,
  which are defined using the typedstruct and Schematic libraries.
  """

  @spec_url "https://raw.githubusercontent.com/modelcontextprotocol/specification/refs/heads/main/schema/2025-03-26/schema.json"

  require Logger
  alias MCP.Protocol.Generator.{Parser, CodeGenerator, FileWriter}

  @doc """
  Generate the protocol modules by fetching the spec and generating code from it.
  """
  def generate do
    with {:ok, spec_json} <- fetch_specification(),
         {:ok, parsed_spec} <- Parser.parse(spec_json),
         {:ok, generated_modules} <- CodeGenerator.generate(parsed_spec) do
      FileWriter.write_files(generated_modules)
    else
      {:error, reason} ->
        Logger.error("Failed to generate protocol: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Fetches the specification from the GitHub repository.
  """
  def fetch_specification do
    case Req.get(@spec_url) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status_code}} ->
        {:error, "Failed to fetch specification: HTTP #{status_code}"}

      {:error, reason} ->
        {:error, "Failed to fetch specification: #{inspect(reason)}"}
    end
  end
end
