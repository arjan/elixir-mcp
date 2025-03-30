# codegen: do not edit
defmodule MCP.Protocol.Structures.LoggingLevel do
  @type t :: String.t()

  import Schematic, warn: false

  @spec alert() :: String.t()
  def alert, do: "alert"

  @spec critical() :: String.t()
  def critical, do: "critical"

  @spec debug() :: String.t()
  def debug, do: "debug"

  @spec emergency() :: String.t()
  def emergency, do: "emergency"

  @spec error() :: String.t()
  def error, do: "error"

  @spec info() :: String.t()
  def info, do: "info"

  @spec notice() :: String.t()
  def notice, do: "notice"

  @spec warning() :: String.t()
  def warning, do: "warning"

  @doc false
  @spec schematic() :: Schematic.t()
  def schematic() do
    oneof([
      "alert",
      "critical",
      "debug",
      "emergency",
      "error",
      "info",
      "notice",
      "warning"
    ])
  end
end
