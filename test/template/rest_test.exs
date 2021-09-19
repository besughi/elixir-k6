defmodule K6.Template.RestTest do
  use ExUnit.Case, async: true
  alias K6.Template.Rest

  @tag :tmp_dir
  test "generates a rest test for the given url", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    Rest.generate_and_save(path, url: "http://api.example.com/")

    assert File.read!(path) =~ ~s[let res = http.post('http://api.example.com/', data);]
  end
end
