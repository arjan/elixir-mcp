# Model Context Protocol SDK for Elixir

A toolkit for building servers (and clients!) that enable LLMs to call tools and access context.

[![MCP Protocol CI](https://github.com/arjan/elixir-mcp/actions/workflows/mcp_protocol.yml/badge.svg)](https://github.com/arjan/elixir-mcp/actions/workflows/mcp_protocol.yml)
[![MCP Server CI](https://github.com/arjan/elixir-mcp/actions/workflows/mcp_server.yml/badge.svg)](https://github.com/arjan/elixir-mcp/actions/workflows/mcp_server.yml)

[![Hex.pm](https://img.shields.io/hexpm/v/mcp_protocol)](https://hex.pm/packages/mcp_protocol)
[![Hex.pm](https://img.shields.io/hexpm/v/mcp_server)](https://hex.pm/packages/mcp_server)
[![Hex.pm](https://img.shields.io/hexpm/dt/mcp_protocol)](https://hex.pm/packages/mcp_protocol)
[![Hex.pm](https://img.shields.io/hexpm/dt/mcp_server)](https://hex.pm/packages/mcp_server)
[![License](https://img.shields.io/hexpm/l/mcp_protocol)](https://github.com/arjan/elixir-mcp/blob/main/LICENSE)

> **Note**: This project is currently a work in progress. Features and APIs may change as development continues.

## Overview

Elixir MCP is a modular Elixir project that provides a protocol implementation and server for the MCP (Model Context Protocol). The Model Context Protocol is a framework that defines how machine learning models, particularly those used in NLP, understand and process contextual information. It establishes standardized methods for providing models with appropriate context and background data to improve their understanding and responses. MCP enables consistent communication between AI models and applications, allowing for more accurate and relevant predictions by establishing rules for how models take in, process, and respond to contextual information in a distributed environment.

For more information about the Model Context Protocol, visit the [official documentation](https://modelcontextprotocol.io/introduction).

### Getting started - creating an MCP server

```elixir
defmodule MyServer do
   use MCP.Server, name: "My cool server", version: "1.0.2"

   @impl true
   def init(_args) do
      state = %{}
      {:ok, state}
   end

   @type location_info :: %{
      place_name: String.t()
   }

   @doc """
   Retrieve information about the given document
   """
   @decorate tool_call()
   @spec get_location_info(input :: String.t(), state ::term()) :: location_info()
   def get_location_info(input) do
     %{place_name: input <> "'s place"}
   end
end
```

All public functions that are decorated with `:tool_call` in this module are exposed on the MCP server as tool calls.

### Components

**MCP Protocol** (`mcp_protocol/`)

Contains the core protocol implementation for Model Context Protocol, parsing and valiting its JSON messages. The protocol's structs are generated from [the official spec](https://github.com/modelcontextprotocol/specification/blob/main/schema/2025-03-26/schema.json).


**MCP Server** (`mcp_server/`)
  
Server implementation for the Model Context Protocol, with flexible adapter for communcation to switch between using STDIO or Server-sent events (Plug).


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
