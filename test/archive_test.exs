defmodule K6.ArchiveTest do
  use ExUnit.Case, async: true

  alias K6.Archive

  test "extracts file from zip archives" do
    {:ok, {_filename, data}} =
      :zip.create("test.zip", [{'file1', "content1"}, {'file2', "content2"}], [:memory])

    assert "content2" = Archive.extract!(data, :zip, "file2")
  end

  test "extract nested file from zip archive" do
    {:ok, {_filename, data}} =
      :zip.create("test.zip", [{'my/file1', "content1"}, {'my/file2', "content2"}], [:memory])

    assert "content2" = Archive.extract!(data, :zip, "file2")
  end

  @tag :tmp_dir
  test "extracts nested file from gzipped tar archive", %{tmp_dir: tmp_dir} do
    temp_file_path = Path.join(tmp_dir, "test.tar.gz")

    :ok =
      :erl_tar.create(temp_file_path, [{'my/file1', "content1"}, {'my/file2', "content2"}], [
        :compressed
      ])

    data = File.read!(temp_file_path)

    assert "content2" = Archive.extract!(data, :tar_gz, "file2")
  end
end
