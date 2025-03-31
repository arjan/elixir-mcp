defmodule MCP.Server.Decorator do
  use Decorator.Define, tool: 0

  def tool(body, context) do
    Module.put_attribute(context.module, :tools, {context.name, context.arity})
    body
  end
end
