defmodule K6.Template.WebSocketTest do
  use ExUnit.Case, async: true
  alias K6.Template.WebSocket

  @tag :tmp_dir
  test "generates a websocket test for the given url", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    WebSocket.generate_and_save(path, url: "ws://example.com/")

    assert File.read!(path) =~ ~s["ws://example.com/"]
    assert File.read!(path) =~ ~s[ws.connect]
  end
end
