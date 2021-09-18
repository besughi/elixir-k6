defmodule K6.TargetTest do
  use ExUnit.Case, async: true

  alias K6.Target

  test "returns k6 target version for mac os" do
    assert "k6-v0.34.1-macos-amd64.zip" = Target.get!("v0.34.1")
  end

end
