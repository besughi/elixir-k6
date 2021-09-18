defmodule K6.ArchiveTest do
  use ExUnit.Case, async: true

  alias K6.Archive

  test "extracts file from zip archives" do
    {:ok, {_filename, data}} =
      :zip.create("test.zip", [{'file1', "content1"}, {'file2', "content2"}], [:memory])

    assert {:ok, "content2"} = Archive.extract(data, :zip, "file2")
  end

  test "extract nested file from zip archive" do
    {:ok, {_filename, data}} =
      :zip.create("test.zip", [{'my/file1', "content1"}, {'my/file2', "content2"}], [:memory])

    assert {:ok, "content2"} = Archive.extract(data, :zip, "file2")
  end
end
