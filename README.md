# Elixir Model Context Protocol SDK

[![Build Status](https://github.com/arjan/elixir-mcp/workflows/CI/badge.svg)](https://github.com/arjan/elixir-mcp/actions)
[![Hex.pm](https://img.shields.io/hexpm/v/mcp_protocol)](https://hex.pm/packages/mcp_protocol)
[![Hex.pm](https://img.shields.io/hexpm/v/mcp_server)](https://hex.pm/packages/mcp_server)
[![Hex.pm](https://img.shields.io/hexpm/dt/mcp_protocol)](https://hex.pm/packages/mcp_protocol)
[![Hex.pm](https://img.shields.io/hexpm/dt/mcp_server)](https://hex.pm/packages/mcp_server)
[![License](https://img.shields.io/hexpm/l/mcp_protocol)](https://github.com/arjan/elixir-mcp/blob/main/LICENSE)

> **Note**: This project is currently a work in progress. Features and APIs may change as development continues.

## Overview

Elixir MCP is a modular Elixir project that provides a protocol implementation and server for the MCP (Model Context Protocol). The Model Context Protocol is a framework that defines how machine learning models, particularly those used in NLP, understand and process contextual information. It establishes standardized methods for providing models with appropriate context and background data to improve their understanding and responses. MCP enables consistent communication between AI models and applications, allowing for more accurate and relevant predictions by establishing rules for how models take in, process, and respond to contextual information in a distributed environment.

For more information about the Model Context Protocol, visit the [official documentation](https://modelcontextprotocol.io/introduction).

### Components

**MCP Protocol** (`mcp_protocol/`)

Contains the core protocol implementation for Model Context Protocol, parsing and valiting its JSON messages. The protocol's structs are generated from [the official spec](https://github.com/modelcontextprotocol/specification/blob/main/schema/2025-03-26/schema.json).


**MCP Server** (`mcp_server/`)
  
Server implementation for the Model Context Protocol, with flexible adapter for communcation to switch between using STDIO or Server-sent events (Plug).


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
