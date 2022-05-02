defmodule JorgebotTest do
  use ExUnit.Case
  doctest Jorgebot

  test "greets the world" do
    assert Jorgebot.hello() == :world
  end
end
