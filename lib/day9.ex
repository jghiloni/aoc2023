defmodule Day9 do
  def part1(), do: part1("./inputs/day9.txt")

  def part1(filename) do
    parse_readings(filename) |> Enum.map(&get_extrapolated_next_value/1) |> Enum.sum()
  end

  def parse_readings(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      String.split(line, " ")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn ns ->
        {n, _} = Integer.parse(ns)
        n
      end)
    end)
  end

  def get_extrapolated_next_value(data) do
    [ first | next] =
      1..Enum.count(data)
      |> Enum.reduce_while([data], fn _, acc ->
        [top | _] = acc
        diff = Enum.chunk_every(top, 2, 1, :discard) |> Enum.map(fn [x, y] -> y - x end)

        if Enum.all?(diff, fn x -> x == 0 end) do
          {:halt, [diff] ++ acc}
        else
          {:cont, [diff] ++ acc}
        end
      end)

    extrapolate(first, next)
  end

  def extrapolate(first, next) when length(next) == 0, do: List.last(first)
  def extrapolate(first, next) do
    [next_set | remaining] = next
    last_in_first = List.last(first)
    last_in_next = List.last(next_set)

    extrapolate(next_set ++ [last_in_first + last_in_next], remaining)
  end
end
