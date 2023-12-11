defmodule Day8 do
  @line_re ~r/^(?<node>\w+) = \((?<left>\w+), (?<right>\w+)\)$/

  def part1(), do: part1("./inputs/day8.txt")

  def part1(filename) do
    filename |> load_map |> count_steps
  end

  def load_map(filename) do
    [dir | nodes] =
      filename
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn l -> l != "" end)

    map =
      nodes
      |> Enum.reduce(%{}, fn line, nodemap ->
        groups = Regex.named_captures(@line_re, line)
        IO.inspect(groups)

        if groups == nil do
          nodemap
        else
          Map.put_new(nodemap, groups["node"], {groups["left"], groups["right"]})
        end
      end)

    {dir, map}
  end

  def count_steps({dir, map}, starting_point \\ "AAA", running_total \\ 0) do
    m = dir
    |> String.graphemes()
    |> Enum.reduce_while(
      %{:starting_point => starting_point, :cont => true, :total => running_total},
      fn step, acc ->
        starting_point = acc.starting_point

        if starting_point == "ZZZ" do
          {:halt, %{acc | :cont => false}}
        else
          {left, right} = Map.get(map, starting_point)

          {_, acc} = Map.get_and_update(acc, :total, fn t -> {t, t + 1} end)
          case step do
            "L" ->
              IO.puts("one step left from #{starting_point} is #{left}")
              acc = %{acc | :starting_point => left}
              {:cont, acc}
            "R" ->
              IO.puts("one step right from #{starting_point} is #{right}")
              acc = %{acc | :starting_point => right}
              {:cont, acc}
          end
        end
      end)

    if m.cont do
      count_steps({dir, map}, m.starting_point, m.total)
    else
      m.total
    end
  end
end
