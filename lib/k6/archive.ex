defmodule K6.Archive do
  def extract(archive_body, _archive_type, file_name) do
    {:ok, archive} = :zip.zip_open(archive_body, [:memory])
    {:ok, list_dir} = :zip.zip_list_dir(archive)

    target_file =
      list_dir
      |> Enum.find_value(fn
        {:zip_file, name, _info, _comment, _offset, _comp_size} ->
          if Path.basename(to_string(name)) == file_name, do: name

        _ ->
          nil
      end)

    {:ok, {_file_name, content}} = :zip.zip_get(target_file, archive)
    :zip.zip_close(archive)

    {:ok, content}
  end
end
