defmodule MCP.Protocol.Generator.CodeGenerator do
  @moduledoc """
  Generates Elixir code from the parsed MCP specification.
  """

  @type_mapping %{
    "string" => "String.t()",
    "integer" => "integer()",
    "number" => "number()",
    "boolean" => "boolean()",
    "null" => "nil",
    "array" => "list()",
    "object" => "map()"
  }

  # Define schematic type mapping functions for use in generated code
  defp str(), do: "Schematic.str()"
  defp int(), do: "Schematic.int()"
  defp bool(), do: "Schematic.bool()"
  defp number(), do: "Schematic.number()"

  @doc """
  Generates code from the parsed specification.

  Returns a tuple with:
  - `:ok` and a map containing the generated code by module type and name
  - `:error` and an error message
  """
  def generate(parsed_spec) do
    try do
      generated = %{
        base_types: generate_base_types(),
        error_response: generate_error_response(),
        requests: %{
          main: generate_requests_module(parsed_spec.requests),
          modules: generate_request_modules(parsed_spec.requests)
        },
        notifications: %{
          main: generate_notifications_module(parsed_spec.notifications),
          modules: generate_notification_modules(parsed_spec.notifications)
        },
        structures: generate_structure_modules(parsed_spec.structures),
        enumerations: generate_enumeration_modules(parsed_spec.enumerations),
        type_aliases: generate_type_alias_modules(parsed_spec.type_aliases)
      }

      {:ok, generated}
    rescue
      e -> {:error, "Failed to generate code: #{inspect(e)}"}
    end
  end

  # Generate base types module
  defp generate_base_types do
    """
    # codegen: do not edit
    defmodule MCP.Protocol.BaseTypes do
      @type uri :: String.t()
      @type document_uri :: String.t()
      @type uinteger :: integer()
      @type null :: nil
    end
    """
  end

  # Generate error response module
  defp generate_error_response do
    """
    # codegen: do not edit
    defmodule MCP.Protocol.ErrorResponse do
      @moduledoc \"\"\"
      A Response Message sent as a result of a request.

      If a request doesn't provide a result value the receiver of a request still needs to return a response message to conform to the JSON-RPC specification.

      The result property of the ResponseMessage should be set to null in this case to signal a successful request.
      \"\"\"
      import Schematic

      use TypedStruct

      typedstruct do
        field :data, String.t() | number() | boolean() | list() | map() | nil
        field :code, integer(), enforce: true
        field :message, String.t(), enforce: true
      end

      @spec schematic() :: Schematic.t()
      def schematic() do
        schema(__MODULE__, %{
          optional(:data) => oneof([str(), int(), bool(), list(), map(), nil]),
          code: int(),
          message: str()
        })
      end
    end
    """
  end

  # Generate the main requests module
  defp generate_requests_module(requests) do
    method_clauses =
      requests
      |> Enum.map(fn req ->
        module_name = request_module_name(req.name)

        """
              %{"method" => "#{req.name}"} ->
                MCP.Protocol.Requests.#{module_name}.schematic()
        """
      end)
      |> Enum.join("\n")

    """
    # codegen: do not edit
    defmodule MCP.Protocol.Requests do
      import Schematic

      def new(request) do
        unify(
          oneof(fn
    #{method_clauses}
            _ ->
              {:error, "unexpected request payload"}
          end),
          request
        )
      end
    end
    """
  end

  # Generate the main notifications module
  defp generate_notifications_module(notifications) do
    method_clauses =
      notifications
      |> Enum.map(fn notification ->
        module_name = notification_module_name(notification.name)

        """
              %{"method" => "#{notification.name}"} ->
                MCP.Protocol.Notifications.#{module_name}.schematic()
        """
      end)
      |> Enum.join("\n")

    """
    # codegen: do not edit
    defmodule MCP.Protocol.Notifications do
      import Schematic

      def new(notification) do
        unify(
          oneof(fn
    #{method_clauses}
            _ ->
              {:error, "unexpected notification payload"}
          end),
          notification
        )
      end
    end
    """
  end

  # Generate individual request modules
  defp generate_request_modules(requests) do
    requests
    |> Enum.map(fn request ->
      module_name = request_module_name(request.name)
      {module_name, generate_request_module(request, module_name)}
    end)
    |> Enum.into(%{})
  end

  # Generate individual notification modules
  defp generate_notification_modules(notifications) do
    notifications
    |> Enum.map(fn notification ->
      module_name = notification_module_name(notification.name)
      {module_name, generate_notification_module(notification, module_name)}
    end)
    |> Enum.into(%{})
  end

  # Generate individual structure modules
  defp generate_structure_modules(structures) do
    structures
    |> Enum.map(fn structure ->
      module_name = structure_module_name(structure.name)
      {module_name, generate_structure_module(structure, module_name)}
    end)
    |> Enum.into(%{})
  end

  # Generate individual enumeration modules
  defp generate_enumeration_modules(enumerations) do
    enumerations
    |> Enum.map(fn enum ->
      module_name = enumeration_module_name(enum.name)
      {module_name, generate_enumeration_module(enum, module_name)}
    end)
    |> Enum.into(%{})
  end

  # Generate individual type alias modules
  defp generate_type_alias_modules(type_aliases) do
    type_aliases
    |> Enum.map(fn type_alias ->
      module_name = type_alias_module_name(type_alias.name)
      {module_name, generate_type_alias_module(type_alias, module_name)}
    end)
    |> Enum.into(%{})
  end

  # Generate a single request module
  defp generate_request_module(request, module_name) do
    description =
      if String.trim(request.description) != "",
        do: """
          @moduledoc \"\"\"
          #{request.description}
          \"\"\"
        """,
        else: ""

    # This would be populated based on the parsed structure
    fields = []

    result_type =
      if request.result_type,
        do: "@type result :: MCP.Protocol.Structures.#{request.result_type}.t()",
        else: ""

    params_type = Map.get(request, :params_type, "EmptyParams")

    """
    # codegen: do not edit
    defmodule MCP.Protocol.Requests.#{module_name} do
      #{description}

      import Schematic, warn: false

      use TypedStruct

      @derive Jason.Encoder
      typedstruct do
        field :method, String.t(), default: "#{request.name}"
        field :jsonrpc, String.t(), default: "2.0"
        field :id, integer(), enforce: true
        field :params, MCP.Protocol.Structures.#{params_type}.t()
      end

      #{result_type}

      @doc false
      @spec schematic() :: Schematic.t()
      def schematic() do
        schema(__MODULE__, %{
          method: "#{request.name}",
          jsonrpc: "2.0",
          id: int(),
          params: MCP.Protocol.Structures.#{params_type}.schematic()
        })
      end

      @doc false
      @spec result() :: Schematic.t()
      def result() do
        oneof([
          MCP.Protocol.Structures.#{request.result_type || "EmptyResult"}.schematic(),
          MCP.Protocol.ErrorResponse.schematic()
        ])
      end
    end
    """
  end

  # Generate a single notification module
  defp generate_notification_module(notification, module_name) do
    description =
      if String.trim(notification.description || "") != "",
        do: """
          @moduledoc \"\"\"
          #{notification.description}
          \"\"\"
        """,
        else: ""

    params_type = Map.get(notification, :params_type, "EmptyParams")

    """
    # codegen: do not edit
    defmodule MCP.Protocol.Notifications.#{module_name} do
      #{description}

      import Schematic, warn: false

      use TypedStruct

      @derive Jason.Encoder
      typedstruct do
        field :method, String.t(), default: "#{notification.name}"
        field :jsonrpc, String.t(), default: "2.0"
        field :params, MCP.Protocol.Structures.#{params_type}.t()
      end

      @doc false
      @spec schematic() :: Schematic.t()
      def schematic() do
        schema(__MODULE__, %{
          method: "#{notification.name}",
          jsonrpc: "2.0",
          params: MCP.Protocol.Structures.#{params_type}.schematic()
        })
      end
    end
    """
  end

  # Generate a single structure module
  defp generate_structure_module(structure, module_name) do
    description =
      if String.trim(structure.description || "") != "",
        do: """
          @moduledoc \"\"\"
          #{structure.description}
          \"\"\"
        """,
        else: ""

    fields =
      structure.properties
      |> Enum.map(fn prop ->
        type = map_type(prop.type)
        enforce = if prop.optional, do: "", else: ", enforce: true"
        "    field :#{to_snake_case(prop.name)}, #{type}#{enforce}"
      end)
      |> Enum.join("\n")

    schematic_fields =
      structure.properties
      |> Enum.map(fn prop ->
        field_name = to_snake_case(prop.name)
        json_field = "{\"#{prop.name}\", :#{field_name}}"
        type = map_schematic_type(prop.type)

        if prop.optional do
          "      optional(#{json_field}) => #{type}"
        else
          "      #{json_field} => #{type}"
        end
      end)
      |> Enum.join(",\n")

    """
    # codegen: do not edit
    defmodule MCP.Protocol.Structures.#{module_name} do
      #{description}
      import Schematic, warn: false

      use TypedStruct

      @derive Jason.Encoder
      typedstruct do
    #{fields}
      end

      @doc false
      @spec schematic() :: Schematic.t()
      def schematic() do
        schema(__MODULE__, %{
    #{schematic_fields}
        })
      end
    end
    """
  end

  # Generate a single enumeration module
  defp generate_enumeration_module(enum, module_name) do
    description =
      if String.trim(enum.description || "") != "",
        do: """
          #{enum.description}
        """,
        else: ""

    type = map_base_type(enum.type)

    value_functions =
      enum.values
      |> Enum.map(fn value ->
        value_name = to_snake_case(value.name)

        value_doc =
          if String.trim(value.description || "") != "",
            do: """
            @doc \"\"\"
            #{value.description}
            \"\"\"
            """,
            else: ""

        """
        #{value_doc}
        @spec #{value_name}() :: #{type}
        def #{value_name}, do: #{inspect(value.value)}
        """
      end)
      |> Enum.join("\n\n  ")

    enum_values =
      enum.values
      |> Enum.map(fn value -> inspect(value.value) end)
      |> Enum.join(",\n      ")

    """
    # codegen: do not edit
    defmodule MCP.Protocol.Enumerations.#{module_name} do
      @type t :: #{type}

      import Schematic, warn: false

      #{value_functions}

      @doc false
      @spec schematic() :: Schematic.t()
      def schematic() do
        oneof([
          #{enum_values}
        ])
      end
    end
    """
  end

  # Generate a single type alias module
  defp generate_type_alias_module(type_alias, module_name) do
    description =
      if String.trim(type_alias.description || "") != "",
        do: """
          @moduledoc \"\"\"
          #{type_alias.description}
          \"\"\"
        """,
        else: ""

    type = map_type(type_alias.type)
    schematic_type = map_schematic_type(type_alias.type)

    """
    # codegen: do not edit
    defmodule MCP.Protocol.TypeAlias.#{module_name} do
      #{description}
      import Schematic, warn: false

      @type t :: #{type}

      @doc false
      @spec schematic() :: Schematic.t()
      def schematic() do
        #{schematic_type}
      end
    end
    """
  end

  # Convert a request name to a module name
  defp request_module_name(name) do
    name
    |> String.split("/")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("")
  end

  # Convert a notification name to a module name
  defp notification_module_name(name) do
    name =
      if String.starts_with?(name, "$"),
        do: "Dollar" <> String.replace_prefix(name, "$", ""),
        else: name

    name
    |> String.split("/")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("")
  end

  # Convert a structure name to a module name
  defp structure_module_name(name) do
    # Assuming structure names are already in PascalCase
    name
  end

  # Convert an enumeration name to a module name
  defp enumeration_module_name(name) do
    # Assuming enum names are already in PascalCase
    name
  end

  # Convert a type alias name to a module name
  defp type_alias_module_name(name) do
    # Assuming type alias names are already in PascalCase
    name
  end

  # Convert a string from camelCase or PascalCase to snake_case
  defp to_snake_case(str) do
    str
    |> String.replace(~r/([A-Z])/, "_\\1")
    |> String.downcase()
    |> String.replace_prefix("_", "")
  end

  # Map a JSON schema type to an Elixir type
  defp map_type(type) when is_binary(type) do
    case Map.get(@type_mapping, type) do
      nil ->
        if String.contains?(type, ".") do
          # If it contains a dot, it's likely a reference to another structure
          ref_parts = String.split(type, ".")
          module_name = List.last(ref_parts)
          "MCP.Protocol.Structures.#{module_name}.t()"
        else
          type
        end

      mapped ->
        mapped
    end
  end

  defp map_type(nil), do: "any()"

  # Handle arrays/lists of types
  defp map_type(types) when is_list(types) do
    types_str = Enum.map_join(types, " | ", fn t -> map_type(t) end)
    "(#{types_str})"
  end

  defp map_type(type) when is_map(type) do
    cond do
      Map.has_key?(type, "type") ->
        case type["type"] do
          "array" ->
            item_type = map_type(type["items"])
            "list(#{item_type})"

          "object" ->
            "map()"

          other ->
            Map.get(@type_mapping, other, "any()")
        end

      true ->
        "any()"
    end
  end

  # Map a JSON schema type to a Schematic type
  defp map_schematic_type(type) when is_binary(type) do
    case type do
      "string" ->
        "str()"

      "integer" ->
        "int()"

      "boolean" ->
        "bool()"

      "number" ->
        "number()"

      "array" ->
        "list()"

      "object" ->
        "map()"

      "null" ->
        "nil"

      _ ->
        if String.contains?(type, ".") do
          # If it contains a dot, it's likely a reference to another structure
          ref_parts = String.split(type, ".")
          module_name = List.last(ref_parts)
          "MCP.Protocol.Structures.#{module_name}.schematic()"
        else
          "MCP.Protocol.Structures.#{type}.schematic()"
        end
    end
  end

  defp map_schematic_type(nil), do: "any()"

  # Handle arrays/lists of types
  defp map_schematic_type(types) when is_list(types) do
    types_schematics = Enum.map(types, fn t -> map_schematic_type(t) end)
    "oneof([#{Enum.join(types_schematics, ", ")}])"
  end

  defp map_schematic_type(type) when is_map(type) do
    cond do
      Map.has_key?(type, "type") ->
        case type["type"] do
          "array" ->
            if Map.has_key?(type, "items") do
              item_type = map_schematic_type(type["items"])
              "list(#{item_type})"
            else
              "list()"
            end

          "object" ->
            "map()"

          other ->
            case other do
              "string" -> "str()"
              "integer" -> "int()"
              "boolean" -> "bool()"
              "number" -> "number()"
              "null" -> "nil"
              _ -> "any()"
            end
        end

      true ->
        "any()"
    end
  end

  # Map a base type for enumerations
  defp map_base_type(type) do
    case type do
      "string" -> "String.t()"
      "integer" -> "integer()"
      "number" -> "number()"
      _ -> "any()"
    end
  end
end
