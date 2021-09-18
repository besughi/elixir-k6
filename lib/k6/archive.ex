defmodule K6.Archive do
  @moduledoc """
  Extracts k6 archive
  """

  @doc """
  Extracts archive to a given filename
  """
  @spec extract(binary(), K6.Target.file_type(), String.t()) :: {:ok, binary()} | {:error, any()}
  def extract(archive_body, :zip, filename), do: extract_zip(archive_body, filename)
  def extract(archive_body, :tar_gz, filename), do: extract_tar_gz(archive_body, filename)

  defp extract_zip(archive_body, filename) do
    archive =
      case :zip.zip_open(archive_body, [:memory]) do
        {:ok, archive} -> archive
        {:error, error} -> raise "Failed to open archive: #{inspect(error)}"
      end

    with {:ok, list_dir} <- :zip.zip_list_dir(archive),
         target_file <- Enum.find_value(list_dir, &match_zip_filename(filename, &1)),
         {:ok, {_file_name, content}} <- :zip.zip_get(target_file, archive) do
      :zip.zip_close(archive)
      {:ok, content}
    else
      error ->
        :zip.zip_close(archive)
        error
    end
  end

  defp extract_tar_gz(archive_body, filename) do
    archive =
      case :erl_tar.open({:binary, archive_body}, [:read, :compressed]) do
        {:ok, archive} -> archive
        {:error, error} -> raise "Failed to open archive: #{inspect(error)}"
      end

    with {:ok, list_dir} <- :erl_tar.table(archive),
         target_file <- Enum.find_value(list_dir, &match_tar_filename(filename, &1)),
         {:ok, [{^target_file, file_content}]} <-
           :erl_tar.extract({:binary, archive_body}, [
             {:files, [target_file]},
             :compressed,
             :memory
           ]) do
      :erl_tar.close(archive)
      {:ok, file_content}
    else
      error ->
        :erl_tar.close(archive)
        error
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
