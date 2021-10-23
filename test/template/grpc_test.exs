defmodule K6.Template.GrpcTest do
  use ExUnit.Case, async: true
  alias K6.Template.Grpc

  @tag :tmp_dir
  test "generates a grpc test for the given url", %{tmp_dir: tmp_dir} do
    load_test_path = Path.join(tmp_dir, "test")

    Grpc.generate_and_save(load_test_path, url: "http://api.example.com/")

    assert File.read!(load_test_path) =~
             ~s[client.connect("http://api.example.com/", { plaintext: false })]

    assert File.read!(Path.join(tmp_dir, "definitions/hello.proto")) =~ ~s[package hello;]
  end
end
