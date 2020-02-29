defmodule XrayTest do
  use ExUnit.Case
  doctest Xray

  test "greets the world" do
    assert Xray.hello() == :world
  end
end
