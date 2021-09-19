defmodule K6.Template.GraphqlTest do
  use ExUnit.Case, async: true
  alias K6.Template.Graphql

  @tag :tmp_dir
  test "generates a graphql test for the given url", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    Graphql.generate_and_save(path, url: "http://api.example.com/graphql")

    assert File.read!(path) =~ ~s[http.post('http://api.example.com/graphql']
  end
end
