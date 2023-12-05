defmodule Day3Grid do
  defstruct [:lines, :dimension]
end

defmodule Day3 do
  @part_finder ~r/(?:\.*(?:\D\W)?)*(?<num>\d+)/
  @part_signifier ~r/[^\d\w\.]/

  def setup(filename) do
    lines = filename |> File.stream!() |> Enum.map(&String.trim/1)
    dimension = Enum.count(lines)

    %Day3Grid{lines: lines, dimension: dimension}
  end

  def in_range({x, y}, grid) do
    x >= 0 && x < grid.dimension && y >= 0 && y < grid.dimension
  end

  def append(s1, s2) do
    s1 <> s2
  end

  def prepend(s1, s2) do
    append(s2, s1)
  end

  def part1() do
    part1("./inputs/day3.txt")
  end

  def part2() do
    part2("./inputs/day3.txt")
  end

  def part1(filename) do
    setup(filename) |> get_part_numbers() |> Enum.sum()
  end

  def part2(filename) do
    grid = setup(filename)
    find_gears(grid) |> find_ratios(grid) |> Enum.sum()
  end

  def get_part_numbers(grid) do
    Enum.map(0..(grid.dimension - 1), fn y ->
      line = Enum.fetch!(grid.lines, y)
      parts = get_line_parts(grid, line, 0, y, ["0"])
      parts
    end)
    |> Enum.reduce([], fn parts, line_parts ->
      Enum.concat(line_parts, parts)
    end)
  end

  def get_line_parts(grid, line, x, y, parts) do
    text = String.slice(line, x..String.length(line))
    match = Regex.named_captures(@part_finder, text, return: :index)

    if match == nil do
      parts |> Enum.map(&Integer.parse/1) |> Enum.map(fn {i, _} -> i end)
    else
      {x1, len} = match["num"]
      x2 = x1 + len
      num_str = String.slice(line, x + x1, len)

      if is_part(grid, x + x1, x + x2, y) do
        get_line_parts(grid, line, x + x2, y, parts ++ [num_str])
      else
        get_line_parts(grid, line, x + x2, y, parts)
      end
    end
  end

  def is_part(grid, x1, x2, y) do
    above = (x1 - 1)..x2 |> Enum.map(fn x -> {x, y - 1} end)
    below = (x1 - 1)..x2 |> Enum.map(fn x -> {x, y + 1} end)
    sides = [{x1 - 1, y}, {x2, y}]

    parts =
      (above ++ below ++ sides)
      |> Enum.filter(&in_range(&1, grid))
      |> Enum.filter(fn {x, y} ->
        String.at(Enum.fetch!(grid.lines, y), x) =~ @part_signifier
      end)

    Enum.count(parts) > 0
  end

  def find_gears(grid) do
    Enum.map(0..(grid.dimension - 1), fn y ->
      line = Enum.fetch!(grid.lines, y)

      Enum.map(0..(grid.dimension - 1), fn x ->
        if String.at(line, x) == "*", do: {x, y}, else: :nomatch
      end)
      |> Enum.reject(fn xy -> xy == :nomatch end)
    end)
    |> Enum.reduce([], fn prev, next -> Enum.concat(next, prev) end)
  end

  def find_ratios(xys, grid) do
    xys
    |> Enum.map(&find_numbers(&1, grid))
    |> Enum.filter(fn nums -> Enum.count(nums) == 2 end)
    |> Enum.map(&Enum.product/1)
  end

  def find_numbers({x, y}, grid) do
    Enum.map((x - 1)..(x + 1), fn x ->
      Enum.map((y - 1)..(y + 1), fn y -> {x, y} end)
    end)
    |> Enum.reduce([], fn prev, next -> next ++ prev end)
    |> Enum.reject(fn xy -> xy == {x, y} end)
    |> Enum.filter(&in_range(&1, grid))
    |> Enum.map(fn {x, y} ->
      line = Enum.at(grid.lines, y)
      char = String.at(line, x)

      if is_digit(char) do
        num_str =
          Enum.reduce_while((x - 1)..0, char, fn x1, acc ->
            c1 = String.at(line, x1)

            if is_digit(c1) do
              {:cont, prepend(acc, c1)}
            else
              {:halt, acc}
            end
          end) <>
            Enum.reduce_while((x + 1)..(grid.dimension - 1), "", fn x1, acc ->
              c1 = String.at(line, x1)

              if is_digit(c1) do
                {:cont, append(acc, c1)}
              else
                {:halt, acc}
              end
            end)
        parsed = num_str |> Integer.parse()
        if parsed == :error do
          :error
        else
          elem(parsed, 0)
        end
      else
        -1
      end
    end)
    |> Enum.filter(fn n -> n != :error && n > 0 end) |> MapSet.new()
  end

  def is_digit(c) do
    c >= "0" && c <= "9"
  end
end
