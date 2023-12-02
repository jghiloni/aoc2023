defmodule Day2Bag do
  defstruct red: 0, green: 0, blue: 0

  def fetch(me, key) do
    {:ok, Map.get(me, key)}
  end
end

defmodule Day2Game do
  defstruct [:id, :bags]
end

defmodule Day2 do
  @test_bag %Day2Bag{red: 12, green: 13, blue: 14}
  @id_parser ~r/^Game (?<id>\d+)$/iu
  @bag_parser ~r/(?<num1>\d+) (?<color1>\w+)(?:\s*,\s*(?<num2>\d+) (?<color2>\w+)(?:\s*,\s*(?<num3>\d+) (?<color3>\w+))?)?/iu

  def part1() do part1("./inputs/day2.txt") end
  def part1(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_gamestr/1)
    |> Enum.filter(&is_possible/1)
    |> Enum.reduce(0, fn next, prev -> next.id + prev end)
  end

  def parse_gamestr(line) do
    [header, rounds] = String.split(line, ":") |> Enum.map(&String.trim/1)
    {id, _id} = Regex.named_captures(@id_parser, header)["id"] |> Integer.parse()
    bags = String.split(rounds, ";") |> Enum.map(&String.trim/1) |> Enum.map(&parse_round/1)

    %Day2Game{id: id, bags: bags}
  end

  def parse_round(str) do
    cg = Regex.named_captures(@bag_parser, str)

    bag =
      %Day2Bag{}
      |> set_bag_color(cg["color1"], cg["num1"])
      |> set_bag_color(cg["color2"], cg["num2"])
      |> set_bag_color(cg["color3"], cg["num3"])

    bag
  end

  def set_bag_color(bag, key_str, val_str) do
    if key_str == "" do
      bag
    else
      key = String.to_existing_atom(key_str)
      {val, _} = Integer.parse(val_str)

      put_in(bag, [Access.key!(key)], val)
    end
  end

  def is_possible(game) do
    max_bag = %Day2Bag{
      red: max_key(game.bags, :red),
      green: max_key(game.bags, :green),
      blue: max_key(game.bags, :blue)
    }

    max_bag.red <= @test_bag.red &&
      max_bag.green <= @test_bag.green &&
      max_bag.blue <= @test_bag.blue
  end

  def max_key(bags, color) do
    mb = bags |> Enum.max_by(fn bag -> bag[color] end)
    mb[color]
  end
end
