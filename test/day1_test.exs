defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "part1-test" do
    assert Day1.part1("./inputs/day1_part1_test.txt") == 142
  end

  test "part2-test" do
    assert Day1.part2("./inputs/day1_part2_test.txt") == 281
  end
end
