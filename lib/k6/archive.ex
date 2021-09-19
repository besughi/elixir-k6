defmodule K6.Archive do
  @moduledoc """
  Extracts k6 archive.

  Target archive can be a zip or a tar_gz file.
  """

  @doc """
  Extracts archive to a given filename
  """
  @spec extract!(binary(), K6.Target.file_type(), String.t()) :: binary()
  def extract!(archive_body, :zip, filename), do: extract_zip!(archive_body, filename)
  def extract!(archive_body, :tar_gz, filename), do: extract_tar_gz!(archive_body, filename)

  defp extract_zip!(archive_body, filename) do
    archive =
      case :zip.zip_open(archive_body, [:memory]) do
        {:ok, archive} -> archive
        {:error, error} -> raise "Failed to open archive: #{inspect(error)}"
      end

    with {:ok, list_dir} <- :zip.zip_list_dir(archive),
         target_file <- Enum.find_value(list_dir, &match_zip_filename(filename, &1)),
         {:ok, {_file_name, content}} <- :zip.zip_get(target_file, archive) do
      :zip.zip_close(archive)
      content
    else
      {:error, error} ->
        :zip.zip_close(archive)
        raise "Error extracting file from archive: #{inspect(error)}"
    end
  end

  defp extract_tar_gz!(archive_body, filename) do
    with {:ok, list_dir} <- :erl_tar.table({:binary, archive_body}, [:compressed]),
         target_file <- Enum.find_value(list_dir, &match_tar_filename(filename, &1)),
         {:ok, [{^target_file, file_content}]} <-
           :erl_tar.extract({:binary, archive_body}, [
             {:files, [target_file]},
             :compressed,
             :memory
           ]) do
      file_content
    else
      {:error, error} ->
        raise "Error extracting file from archive: #{inspect(error)}"
    end
  end

  defp match_zip_filename(target, {:zip_file, filename, _info, _comment, _offset, _comp_size}) do
    if Path.basename(to_string(filename)) == target, do: filename
  end

  defp match_zip_filename(_, _), do: nil

  defp match_tar_filename(target, filename) do
    if Path.basename(to_string(filename)) == target, do: filename
  end
end
