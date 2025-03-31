defmodule MCP.Server.Communication.Stdio do
  @moduledoc """
  The Standard IO adapter.

  This is the default adapter, and is the communication channel that most MCP clients expect to be able to use.
  """

  @behaviour MCP.Server.Communication.Adapter

  @impl true
  def init(_) do
    :ok = :io.setopts(encoding: :latin1, binary: true)

    {:ok, nil}
  end

  @impl true
  def listen(state) do
    {:ok, state}
  end

  @impl true
  def write(body, _) do
    IO.binwrite(
      :stdio,
      IO.iodata_to_binary([Jason.encode!(body), "\n"])
    )
  end

  @impl true
  def read(_, _) do
    case IO.read(:stdio, :line) do
      :eof ->
        :eof

      {:error, error} ->
        {:error, error}

      line ->
        File.write!("/tmp/test.log", line, [:append])
        {:ok, Jason.decode!(line), ""}
    end
  end
end
