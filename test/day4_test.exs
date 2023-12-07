defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "part1-test" do
    assert Day4.part1("./inputs/day4_test.txt") == 13
  end

  test "part2-test" do
    assert Day4.part2("./inputs/day4_test.txt") == 30
  end
end
