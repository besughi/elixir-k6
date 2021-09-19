defmodule K6.Template.PhoenixChannelTest do
  use ExUnit.Case, async: true
  alias K6.Template.PhoenixChannel

  @tag :tmp_dir
  test "generates a phoenix-channel test for the given url", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    PhoenixChannel.generate_and_save(path, url: "ws://example.com/socket")

    assert File.read!(path) =~ ~s[Channel("ws://example.com/socket", "my_room:lobby"]
  end
end
