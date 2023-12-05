defmodule Day3 do
  @part_finder ~r/(?:\.*(?:\D\W)?)*(?<num>\d+)/
  @part_signifier ~r/[^\d\w\.]/

  def part1() do
    part1("./inputs/day3.txt")
  end

  def part1(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> get_part_numbers()
    |> Enum.sum()
  end

  def get_part_numbers(lines) do
    Enum.map(0..(Enum.count(lines) - 1), fn y ->
      line = Enum.fetch!(lines, y)
      parts = get_line_parts(lines, line, 0, y, ["0"])
      parts
    end)
    |> Enum.reduce([], fn parts, line_parts ->
      Enum.concat(line_parts, parts)
    end)
  end

  def get_line_parts(lines, line, x, y, parts) do
    text = String.slice(line, x..String.length(line))
    match = Regex.named_captures(@part_finder, text, return: :index)

    if match == nil do
      parts |> Enum.map(&Integer.parse/1) |> Enum.map(fn {i, _} -> i end)
    else
      {x1, len} = match["num"]
      x2 = x1 + len
      num_str = String.slice(line, x + x1, len)

      if is_part(lines, x + x1, x + x2, y) do
        get_line_parts(lines, line, x + x2, y, parts ++ [num_str])
      else
        get_line_parts(lines, line, x + x2, y, parts)
      end
    end
  end

  def is_part(lines, x1, x2, y) do
    above = (x1 - 1)..x2 |> Enum.map(fn x -> {x, y - 1} end)
    below = (x1 - 1)..x2 |> Enum.map(fn x -> {x, y + 1} end)
    sides = [{x1 - 1, y}, {x2, y}]

    dimension = Enum.count(lines)

    parts = (above ++ below ++ sides)
    |> Enum.reject(fn {x, y} ->
      x < 0 || y < 0 || x >= dimension || y >= dimension
    end)
    |> Enum.filter(fn {x, y} ->
      char = String.at(Enum.fetch!(lines, y), x)
      char =~ @part_signifier
    end)

    Enum.count(parts) > 0
  end
end
