defmodule MCP.Protocol.Generator.Parser do
  @moduledoc """
  Parses the MCP specification JSON into structured format for code generation.
  """

  @doc """
  Parse the specification JSON into a structured format.

  Returns a tuple with:
  - `:ok` and a map containing the parsed specification
  - `:error` and an error message
  """
  def parse(json_string) do
    case Jason.decode(json_string) do
      {:ok, spec} ->
        parsed_spec = %{
          requests: parse_requests(spec),
          notifications: parse_notifications(spec),
          structures: parse_structures(spec),
          enumerations: parse_enumerations(spec),
          type_aliases: parse_type_aliases(spec)
        }

        {:ok, parsed_spec}

      {:error, reason} ->
        {:error, "Failed to parse JSON: #{inspect(reason)}"}
    end
  end

  # Extract and parse all request definitions
  defp parse_requests(spec) do
    client_requests = get_in(spec, ["definitions", "ClientRequest", "anyOf"]) || []
    server_requests = get_in(spec, ["definitions", "ServerRequest", "anyOf"]) || []

    (client_requests ++ server_requests)
    |> Enum.uniq()
    |> Enum.map(fn request ->
      ref = request["$ref"]
      definition_name = extract_definition_name(ref)
      definition = get_in(spec, ["definitions", definition_name])

      if definition do
        properties = definition["properties"] || %{}
        method = get_in(properties, ["method", "const"])
        params = get_in(properties, ["params"])

        # Create params type based on the request name - converting from RequestName to ParamsName
        # Example: CallToolRequest -> CallToolParams
        params_type =
          if definition_name =~ "Request" do
            String.replace(definition_name, "Request", "Params")
          else
            "EmptyParams"
          end

        %{
          name: definition_name,
          description: definition["description"] || "",
          method: method,
          params: parse_params(params),
          params_type: params_type,
          result_type: get_result_type_for_request(definition_name, spec),
          kind: :requests
        }
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  # Extract and parse all notification definitions
  defp parse_notifications(spec) do
    client_notifications = get_in(spec, ["definitions", "ClientNotification", "anyOf"]) || []
    server_notifications = get_in(spec, ["definitions", "ServerNotification", "anyOf"]) || []

    (client_notifications ++ server_notifications)
    |> Enum.uniq()
    |> Enum.map(fn notification ->
      ref = notification["$ref"]
      definition_name = extract_definition_name(ref)
      definition = get_in(spec, ["definitions", definition_name])

      if definition do
        properties = definition["properties"] || %{}
        method = get_in(properties, ["method", "const"])
        params = get_in(properties, ["params"])

        # Create params type based on the notification name, converting from NotificationName to ParamsName
        # Example: ResourceUpdatedNotification -> ResourceUpdatedParams
        params_type =
          if definition_name =~ "Notification" do
            String.replace(definition_name, "Notification", "Params")
          else
            "EmptyParams"
          end

        %{
          name: definition_name,
          description: definition["description"] || "",
          method: method,
          params: parse_params(params),
          params_type: params_type,
          kind: :notifications
        }
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  # Extract and parse all structure definitions
  defp parse_structures(spec) do
    definitions = spec["definitions"] || %{}

    # Create list of custom param structures based on requests and notifications
    param_structures =
      Enum.concat(
        # Convert requests to param structures
        Enum.map(
          (get_in(spec, ["definitions", "ClientRequest", "anyOf"]) || []) ++
            (get_in(spec, ["definitions", "ServerRequest", "anyOf"]) || []),
          fn req ->
            ref = req["$ref"]
            req_name = extract_definition_name(ref)
            req_def = get_in(spec, ["definitions", req_name])

            if req_def && req_def["properties"] && req_def["properties"]["params"] do
              params = req_def["properties"]["params"]
              params_name = String.replace(req_name, "Request", "Params")

              %{
                name: params_name,
                description: "Parameters for #{req_name}",
                properties: parse_properties(params["properties"] || %{}),
                required: params["required"] || []
              }
            else
              nil
            end
          end
        )
        |> Enum.reject(&is_nil/1),

        # Convert notifications to param structures
        Enum.map(
          Enum.uniq(
            (get_in(spec, ["definitions", "ClientNotification", "anyOf"]) || []) ++
              (get_in(spec, ["definitions", "ServerNotification", "anyOf"]) || [])
          ),
          fn notif ->
            ref = notif["$ref"]
            notif_name = extract_definition_name(ref)
            notif_def = get_in(spec, ["definitions", notif_name])

            if notif_def && notif_def["properties"] && notif_def["properties"]["params"] do
              params = notif_def["properties"]["params"]
              params_name = String.replace(notif_name, "Notification", "Params")

              %{
                name: params_name,
                description: "Parameters for #{notif_name}",
                properties: parse_properties(params["properties"] || %{}),
                required: params["required"] || [],
                kind: :structures
              }
            else
              nil
            end
          end
        )
        |> Enum.reject(&is_nil/1)
      )

    # Extract regular structures
    regular_structures =
      definitions
      |> Enum.filter(fn {_name, definition} ->
        is_map(definition) &&
          definition["type"] == "object" &&
          definition["properties"] != nil &&
          !Map.has_key?(definition, "enum")
      end)
      |> Enum.map(fn {name, definition} ->
        %{
          name: name,
          description: definition["description"] || "",
          properties: parse_properties(definition["properties"] || %{}),
          required: definition["required"] || [],
          kind: :structures
        }
      end)

    # Merge regular structures with custom param structures
    regular_structures ++ param_structures
  end

  # Extract and parse all enum definitions
  defp parse_enumerations(spec) do
    definitions = spec["definitions"] || %{}

    definitions
    |> Enum.filter(fn {_name, definition} ->
      is_map(definition) && Map.has_key?(definition, "enum")
    end)
    |> Enum.map(fn {name, definition} ->
      %{
        name: name,
        description: definition["description"] || "",
        values: parse_enum_values(definition["enum"] || []),
        type: definition["type"] || "string",
        kind: :enumerations
      }
    end)
  end

  # Extract and parse all type alias definitions
  defp parse_type_aliases(spec) do
    definitions = spec["definitions"] || %{}

    definitions
    |> Enum.filter(fn {_name, definition} ->
      is_map(definition) &&
        !is_nil(definition["type"]) &&
        definition["type"] != "object" &&
        !Map.has_key?(definition, "enum") &&
        !Map.has_key?(definition, "properties")
    end)
    |> Enum.map(fn {name, definition} ->
      %{
        name: name,
        description: definition["description"] || "",
        type: definition["type"],
        kind: :type_aliases
      }
    end)
  end

  # Helper function to extract definition name from a reference
  defp extract_definition_name(ref) when is_binary(ref) do
    ref
    |> String.replace("#/definitions/", "")
  end

  defp extract_definition_name(_), do: nil

  # Determine the result type for a request
  defp get_result_type_for_request(request_name, spec) do
    # First check if there's a specific result for this request
    result_name = "#{request_name}Result"

    cond do
      # Check if there's a direct result type definition
      Map.has_key?(spec["definitions"] || %{}, result_name) ->
        result_name

      # Special case for InitializeRequest -> InitializeResult
      request_name == "InitializeRequest" ->
        "InitializeResult"

      # Otherwise look in client/server result types
      true ->
        client_results = get_in(spec, ["definitions", "ClientResult", "anyOf"]) || []
        server_results = get_in(spec, ["definitions", "ServerResult", "anyOf"]) || []

        # Search for the specific result in anyOf arrays
        matching_result =
          (client_results ++ server_results)
          |> Enum.uniq()
          |> Enum.find(fn result ->
            ref = result["$ref"]
            ref_name = extract_definition_name(ref)
            ref_name == result_name
          end)

        if matching_result do
          extract_definition_name(matching_result["$ref"])
        else
          # Default
          "Result"
        end
    end
  end

  # Parse parameters of a request or notification
  defp parse_params(params) when is_map(params) do
    %{
      properties: parse_properties(params["properties"] || %{}),
      required: params["required"] || []
    }
  end

  defp parse_params(_), do: %{properties: [], required: []}

  # Parse properties of a structure
  defp parse_properties(properties) do
    properties
    |> Enum.map(fn {name, prop} ->
      %{
        name: name,
        description: prop["description"] || "",
        type: determine_property_type(prop),
        optional: not_required(name, prop)
      }
    end)
  end

  # Determine if a property is optional
  defp not_required(name, prop) do
    parent = prop["$parent"]
    required = (parent && parent["required"]) || []
    not Enum.member?(required, name)
  end

  # Determine the type of a property
  defp determine_property_type(prop) do
    cond do
      prop["$ref"] -> extract_definition_name(prop["$ref"])
      prop["type"] -> prop["type"]
      prop["anyOf"] -> "map()"
      prop["const"] -> "const:#{prop["const"]}"
      true -> "any"
    end
  end

  # Parse values of an enumeration
  defp parse_enum_values(values) do
    values
    |> Enum.map(fn value ->
      case value do
        %{"name" => name, "value" => enum_value, "documentation" => docs} ->
          %{name: name, value: enum_value, description: docs}

        %{"name" => name, "value" => enum_value} ->
          %{name: name, value: enum_value, description: ""}

        _ when is_binary(value) ->
          %{name: String.replace(value, ~r/[^a-zA-Z0-9_]/, "_"), value: value, description: ""}
      end
    end)
  end
end
