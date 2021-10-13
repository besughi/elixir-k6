defmodule K6.Template.GrpcTest do
  use ExUnit.Case, async: true
  alias K6.Template.Grpc

  @tag :tmp_dir
  test "generates a grpc test for the given url", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    Grpc.generate_and_save(path, url: "http://api.example.com/")

    assert File.read!(path) =~ ~s[client.connect("http://api.example.com/", { plaintext: false })]
  end
end
