defmodule Day1 do
  @digits ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  @words ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  def part1(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&get_number(&1, @digits))
    |> Enum.reduce(0, fn next, prev -> next + prev end)
  end

  def part2(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&get_number(&1, @digits ++ @words))
    |> Enum.reduce(0, fn next, prev -> next + prev end)
  end

  def get_number(line, digits) do
    {num, _} =
      (get_first_number_string(line, digits) <> get_last_number_string(line, digits))
      |> Integer.parse()

    num
  end

  def get_first_number_string(line, digits) do
    all_found =
      digits
      |> Enum.map(fn digit -> :binary.match(line, digit) end)
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Enum.filter(fn el -> elem(el, 1) != :nomatch end)

    if length(all_found) > 0 do
      first = all_found |> Enum.min_by(fn m -> elem(elem(m, 1), 0) end)
      "#{Integer.mod(elem(first, 0), 10)}"
    else
      ""
    end
  end

  def get_last_number_string(line, digits) do
    get_first_number_string(String.reverse(line), Enum.map(digits, &String.reverse/1))
  end
end
