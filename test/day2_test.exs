defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "part1-test" do
    assert Day2.part1("./inputs/day2_test.txt") == 8
  end

  test "part2-test" do
    assert Day2.part2("./inputs/day2_test.txt") == 2286
  end
end
