defmodule MCP.Server.Compiler do
  defmacro __before_compile__(env) do
    tools = Module.get_attribute(env.module, :tools)
    IO.inspect(tools)
    IO.puts("--------------------------------")

    quote do
      def __mcp__() do
        %{
          tools: unquote(tools)
        }
      end
    end
  end

  defmacro __after_compile__(env, _bytecode) do
    mod = Module.concat(env.module, MCPMeta)

    Code.Typespec.fetch_specs(env.module) |> IO.inspect()

    Module.create(
      mod,
      quote do
        def lala, do: "lala"
      end,
      file: "nofile"
    )

    :ok
  end
end
