defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "part1-test" do
    assert Day9.part1("./inputs/day9_test.txt") == 114
  end

  test "part2-test" do
    assert Day9.part2("./inputs/day9_test.txt") == 2
  end
end
