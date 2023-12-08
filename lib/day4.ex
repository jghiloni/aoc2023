defmodule Day4Card do
  defstruct [:id, :winning_numbers, :my_numbers]
end

defmodule Day4Copies do
  defstruct [:id, :copies]
end

defmodule Day4 do
  def part1() do
    part1("./inputs/day4.txt")
  end

  def part2() do
    part2("./inputs/day4.txt")
  end

  def setup(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_card/1)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  def part1(filename) do
    setup(filename)
    |> Enum.map(&get_card_score/1)
    |> Enum.sum()
  end

  def part2(filename) do
    cards = setup(filename)

    copies =
      cards
      |> Enum.map(&make_copy/1)
      |> Enum.reduce(%{}, fn copy, acc -> Map.merge(acc, copy) end)

    Map.keys(copies)
    |> Enum.sort()
    |> update_copies(copies, cards)
    |> Enum.map(fn {_, copy} -> copy.copies end)
    |> Enum.sum()
  end

  def make_copy({id, _}) do
    %{id => %Day4Copies{id: id, copies: 1}}
  end

  def update_copies(ids, copies, _cardmap) when length(ids) == 0, do: copies

  def update_copies(ids, copies, cardmap) do
    [first | rest] = ids
    IO.inspect({first, copies})

    card = Map.get(cardmap, first)
    copy = Map.get(copies, first)

    if card == nil do
      update_copies(rest, copies, cardmap)
    else
      updated_copies =
        win_range(card)
        |> Enum.reduce(copies, fn id, acc ->
          {_, acc} =
            Map.get_and_update!(acc, id, fn c ->
              {c, %Day4Copies{id: id, copies: c.copies + copy.copies}}
            end)

          acc
        end)

      update_copies(rest, updated_copies, cardmap)
    end
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

    %{id => %Day4Card{id: id, winning_numbers: winning, my_numbers: mine}}
  end

  def get_card_score({_, card}) do
    my_winning_numbers = MapSet.intersection(card.winning_numbers, card.my_numbers)
    (2 ** (MapSet.size(my_winning_numbers) - 1)) |> trunc
  end

  def win_range(card) do
    count =
      MapSet.intersection(card.winning_numbers, card.my_numbers)
      |> MapSet.size()

    if count == 0 do
      []
    else
      (card.id + 1)..(card.id + count) |> Range.to_list()
    end
  end
end
