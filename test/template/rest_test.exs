defmodule K6.Template.RestTest do
  use ExUnit.Case, async: true

  @tag :tmp_dir
  test "generates a rest test for the given url", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    K6.Template.Rest.generate(path, url: "http://api.example.com/")

    assert File.read!(path) =~ ~s[let res = http.post('http://api.example.com/', data);]
  end
end
