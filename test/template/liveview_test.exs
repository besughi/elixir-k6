defmodule K6.Template.LiveviewTest do
  use ExUnit.Case, async: true
  alias K6.Template.Liveview

  @tag :tmp_dir
  test "generates a phoenix-liveview test", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "test")

    Liveview.generate_and_save(path, url: "ws://example.com/live/websocket")

    generated = File.read!(path)

    assert generated =~ "let liveview = new Liveview("
    assert generated =~ "http://example.com"
    assert generated =~ "ws://example.com/live/websocket"
  end
end
