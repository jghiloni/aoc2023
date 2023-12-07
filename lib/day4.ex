defmodule Day4Card do
  defstruct [:id, :winning_numbers, :my_numbers]
end

defmodule Day4 do
  def part1() do
    part1("./inputs/day4.txt")
  end

  def part2() do
    part2("./inputs/day4.txt")
  end

  def setup(filename) do
    filename |> File.stream!() |> Enum.map(&String.trim/1) |> Enum.map(&parse_card/1)
  end

  def part1(filename) do
    setup(filename)
    |> Enum.map(&get_card_score/1)
    |> Enum.sum()
  end

  def part2(filename) do
    cards =
      setup(filename)

    max_id = Enum.max_by(cards, fn c -> c.id end).id

    map =
      cards
      |> Enum.map(&get_win_range(&1, max_id))
      |> Enum.reduce(%{}, &Map.merge/2)
      |> IO.inspect()

    Map.keys(map)
    |> Enum.map(fn id ->
      id..1
      |> Enum.map(fn i ->
        list = Map.get(map, i)

        if list != nil do
          Enum.find_value(list, 0, fn x -> if id == x, do: 1, else: 0 end)
        else
          0
        end
      end)
      |> Enum.sum()
    end)
  end

  def parse_card(line) do
    [head, card] = String.split(line, ":") |> Enum.map(&String.trim/1)
    {id, _} = head |> String.replace_prefix("Card ", "") |> String.trim() |> Integer.parse()

    [winning, mine] =
      card
      |> String.split(" | ")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn num_list -> num_list |> Enum.map(&Integer.parse/1) end)
      |> Enum.map(fn parsed -> parsed |> Enum.filter(fn p -> p != :error end) end)
      |> Enum.map(fn plist -> plist |> Enum.map(fn {n, _} -> n end) end)
      |> Enum.map(&MapSet.new/1)

    %Day4Card{id: id, winning_numbers: winning, my_numbers: mine}
  end

  def get_card_score(card) do
    my_winning_numbers = MapSet.intersection(card.winning_numbers, card.my_numbers)
    (2 ** (MapSet.size(my_winning_numbers) - 1)) |> trunc
  end

  def get_win_range(card, max_id) do
    size = MapSet.intersection(card.winning_numbers, card.my_numbers) |> MapSet.size()

    if size > 0 do
      Map.put(%{}, card.id, min(max_id, card.id + 1)..(card.id + size) |> Range.to_list())
    else
      Map.put(%{}, card.id, [card.id])
    end
  end
end
