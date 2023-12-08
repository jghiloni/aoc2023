defmodule Day6 do
  def part1(), do: part1("./inputs/day6.txt")

  def part1(filename) do
    [time_strings | [distance_strings]] = File.stream!(filename) |> Enum.map(&String.trim/1)
    [_ | times] = Regex.split(~r/\s+/, time_strings)
    [_ | distances] = Regex.split(~r/\s+/, distance_strings)

    Enum.zip(times, distances)
    |> Enum.map(fn {timeStr, distStr} ->
      {time, _} = timeStr |> Integer.parse()
      {distance, _} = distStr |> Integer.parse()
      {time, distance}
    end)
    |> IO.inspect()
    |> Enum.map(fn {time, distance} ->
      midpoint = ceil(time / 2)

      earliest =
        1..midpoint
        |> Enum.find(fn t ->
          (time - t) * t > distance
        end)

      latest = time - earliest
      IO.puts("#{earliest}, #{latest}")

      latest - earliest + 1
    end)
    |> IO.inspect()
    |> Enum.product()
  end
end
