defmodule K6.Integration.DownloaderTest do
  use ExUnit.Case, async: true

  alias K6.Downloader

  test "downloads k6 given a version" do
    :inets.start()
    :ssl.start()

    assert {_type, binary} = Downloader.download!("v0.34.1")
    assert is_binary(binary)
  end
end
