defmodule K6.TargetTest do
  use ExUnit.Case, async: true

  alias K6.Target

  test "returns k6 target for macos" do
    os_type = fn ->
      {:unix, :darwin}
    end

    assert {:zip, "k6-v0.34.1-macos-amd64.zip"} = Target.get!("v0.34.1", os_type)
  end

  test "returns k6 target for linux" do
    os_type = fn ->
      {:unix, :linux}
    end

    assert {:tar_gz, "k6-v0.34.1-linux-amd64.tar.gz"} = Target.get!("v0.34.1", os_type)
  end
end
