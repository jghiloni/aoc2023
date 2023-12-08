defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "part1-test" do
    assert Day6.part1("./inputs/day6_test.txt") == 288
  end

  test "part2-test" do
    assert Day6.part2("./inputs/day6_test.txt") == 71503
  end
end
