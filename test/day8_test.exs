defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "part1-test1" do
    assert Day8.part1("./inputs/day8_test1.txt") == 2
  end

  test "part1-test2" do
    assert Day8.part1("./inputs/day8_test2.txt") == 6
  end
end
