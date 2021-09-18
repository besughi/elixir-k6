defmodule K6Test do
  use ExUnit.Case
  doctest K6

  test "greets the world" do
    assert K6.hello() == :world
  end
end
