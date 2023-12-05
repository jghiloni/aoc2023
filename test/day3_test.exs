defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "part1-test" do
    assert Day3.part1("./inputs/day3_test.txt") == 4361
  end

  test "part2-test" do
    assert Day3.part2("./inputs/day3_test.txt") == 467835
  end
end
