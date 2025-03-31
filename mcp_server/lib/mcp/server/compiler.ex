defmodule MCP.Server.Compiler do
  def __before_compile__(env) do
    tools = Module.get_attribute(env.module, :tools)
    IO.inspect(tools)
    IO.puts("--------------------------------")

    quote do
      def __mcp__() do
        %{
          tools: unquote(tools)
        }
      end

      def hello, do: "world"
    end
  end
end
