defmodule K6.Archive do
  @doc """
  Extracts archive to a given filename
  """
  def extract(archive_body, _archive_type, file_name) do
    archive =
      case :zip.zip_open(archive_body, [:memory]) do
        {:ok, archive} -> archive
        {:error, error} -> raise "Failed to open archive: #{inspect(error)}"
      end

    with {:ok, list_dir} <- :zip.zip_list_dir(archive),
         target_file <- Enum.find_value(list_dir, &match_file_name(file_name, &1)),
         {:ok, {_file_name, content}} <- :zip.zip_get(target_file, archive) do
      :zip.zip_close(archive)
      {:ok, content}
    else
      error ->
        :zip.zip_close(archive)
        error
    end
  end

  defp match_file_name(file_name, {:zip_file, name, _info, _comment, _offset, _comp_size}) do
    if Path.basename(to_string(name)) == file_name, do: name
  end

  defp match_file_name(_, _), do: nil
end
