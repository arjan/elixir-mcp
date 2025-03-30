defmodule MCP.Protocol.Generator.FileWriter do
  @moduledoc """
  Writes the generated code to files in the appropriate directory structure.
  """

  @base_dir "lib/mcp/protocol"

  @doc """
  Writes the generated modules to files in the appropriate directories.

  Returns a tuple with:
  - `:ok` and a list of files that were written
  - `:error` and an error message
  """
  def write_files(generated_modules) do
    try do
      # Ensure all directories exist
      ensure_directories()

      # Write base types
      write_file("#{@base_dir}/base_types.ex", generated_modules.base_types)

      # Write error response
      write_file("#{@base_dir}/error_response.ex", generated_modules.error_response)

      # Write main requests module
      write_file("#{@base_dir}/requests.ex", generated_modules.requests.main)

      # Write main notifications module
      write_file("#{@base_dir}/notifications.ex", generated_modules.notifications.main)

      # Write individual request modules
      Enum.each(generated_modules.requests.modules, fn {name, content} ->
        write_file("#{@base_dir}/requests/#{module_to_filename(name)}.ex", content)
      end)

      # Write individual notification modules
      Enum.each(generated_modules.notifications.modules, fn {name, content} ->
        write_file("#{@base_dir}/notifications/#{module_to_filename(name)}.ex", content)
      end)

      # Write structure modules
      Enum.each(generated_modules.structures, fn {name, content} ->
        write_file("#{@base_dir}/structures/#{module_to_filename(name)}.ex", content)
      end)

      # Write enumeration modules
      Enum.each(generated_modules.enumerations, fn {name, content} ->
        write_file("#{@base_dir}/enumerations/#{module_to_filename(name)}.ex", content)
      end)

      # Write type alias modules
      Enum.each(generated_modules.type_aliases, fn {name, content} ->
        write_file("#{@base_dir}/type_aliases/#{module_to_filename(name)}.ex", content)
      end)

      {:ok, "All files written successfully"}
    rescue
      e -> {:error, "Failed to write files: #{inspect(e)}"}
    end
  end

  # Make all necessary directories
  defp ensure_directories do
    [
      "#{@base_dir}/requests",
      "#{@base_dir}/notifications",
      "#{@base_dir}/structures",
      "#{@base_dir}/enumerations",
      "#{@base_dir}/type_aliases"
    ]
    |> Enum.each(&File.mkdir_p!/1)
  end

  # Write a file with the given content
  defp write_file(path, content) do
    File.write!(path, content)
  end

  # Convert a module name to a filename
  defp module_to_filename(module_name) do
    Macro.underscore(module_name)
  end
end
