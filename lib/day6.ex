defmodule Day6 do
  def part1(), do: part1("./inputs/day6.txt")
  def part2(), do: part2("./inputs/day6.txt")

  def part1(filename) do
    [time_strings | [distance_strings]] = File.stream!(filename) |> Enum.map(&String.trim/1)
    [_ | times] = Regex.split(~r/\s+/, time_strings)
    [_ | distances] = Regex.split(~r/\s+/, distance_strings)

    Enum.zip(times, distances)
    |> Enum.map(&count_winning_possibilites/1)
    |> Enum.product()
  end

  def part2(filename) do
    [timeline | [distline]] =
      File.stream!(filename)
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn line -> String.replace(line, " ", "") end)

    [_ | [time_str]] = String.split(timeline, ":")
    [_ | [dist_str]] = String.split(distline, ":")

    count_winning_possibilites({time_str, dist_str})
  end

  def count_winning_possibilites({timeStr, distStr}) do
    {time, _} = timeStr |> Integer.parse()
    {distance, _} = distStr |> Integer.parse()

    earliest =
      1..ceil(time / 2)
      |> Enum.find(fn t ->
        (time - t) * t > distance
      end)

    latest = time - earliest
    latest - earliest + 1
  end
end
