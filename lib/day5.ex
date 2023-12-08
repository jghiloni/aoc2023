defmodule Day5Map do
  defstruct [:from, :to, :ranges]
end

defmodule Day5Range do
  defstruct [:from, :to]
end

defmodule Day5Input do
  defstruct [:seeds, :maps]
end

defmodule Day5 do
  @map_break ~r/(?<from>\w+)-to-(?<to>\w+) map:/
  @range_line ~r/(?<to_start>\d+) (?<from_start>\d+) (?<range_size>\d+)/

  def part1(), do: part1("./inputs/day5.txt")

  def part1(filename) do
    input = build_input(filename)

    input.seeds
    |> Enum.map(fn seed -> translate_value(seed, input, "seed", "location") end)
    |> Enum.min()
  end

  def build_input(filename) do
    [seedline | lines] = File.stream!(filename) |> Enum.map(&String.trim/1)

    [_ | [seedstr | _]] =
      seedline
      |> String.split(":")
      |> Enum.map(&String.trim/1)

    seeds =
      String.split(seedstr, " ")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn {n, _} -> n end)

    parse_line(lines, %Day5Input{seeds: seeds, maps: []}, nil)
  end

  def parse_line(lines, input, map) when length(lines) == 0 do
    %Day5Input{seeds: input.seeds, maps: input.maps ++ [map]}
  end

  def parse_line([first | rem], input, map) when first == "", do: parse_line(rem, input, map)

  def parse_line([first | rem], input, map) do
    if first =~ @map_break do
      captures = Regex.named_captures(@map_break, first)
      new_map = %Day5Map{from: captures["from"], to: captures["to"], ranges: []}

      if map != nil do
        new_input = %Day5Input{seeds: input.seeds, maps: input.maps ++ [map]}
        parse_line(rem, new_input, new_map)
      else
        parse_line(rem, input, new_map)
      end
    else
      if first =~ @range_line do
        captures = Regex.named_captures(@range_line, first)
        {fs, _} = captures["from_start"] |> Integer.parse()
        {ts, _} = captures["to_start"] |> Integer.parse()
        {rg, _} = captures["range_size"] |> Integer.parse()
        range = %Day5Range{from: fs..(fs + rg - 1), to: ts..(ts + rg - 1)}
        new_map = %Day5Map{from: map.from, to: map.to, ranges: map.ranges ++ [range]}
        parse_line(rem, input, new_map)
      end
    end
  end

  def translate_value(value, input, from, to) do
    map = input.maps |> Enum.find(fn m -> from == m.from end)

    if map == nil do
      value
    else
      range =
        map.ranges
        |> Enum.find(%Day5Range{from: value..value, to: value..value}, fn r ->
          Enum.member?(r.from, value)
        end)

      if map.to == to do
        value
      end

      offset = value - range.from.first
      to_value = range.to.first + offset
      translate_value(to_value, input, map.to, to)
    end
  end
end
