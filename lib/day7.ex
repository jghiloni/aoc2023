defmodule Day7 do
  @cards %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  @hands %{
    :highcard => 1,
    :pair => 2,
    :twopair => 3,
    :trips => 4,
    :boat => 5,
    :quads => 6,
    :quints => 7
  }
  def part1(), do: part1("./inputs/day7.txt")

  def part1(filename) do
    [lowest | rest] = parse_hands(filename)
    |> Enum.sort(&rank_hands/2)

    {_, bet} = lowest
    rest |> Enum.reduce([{1, bet}], fn ranked_bet, acc ->
      [{rank, _} | _] = acc
      {_, bid} = ranked_bet
      [{rank + 1, (rank + 1) * bid}] ++ acc
    end)
    |> Enum.reduce(0, fn rb, acc ->
      {_, winnings} = rb
      acc + winnings
    end)
  end

  def parse_hands(filename) do
    File.stream!(filename)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      [hand_str | [bid_str]] = String.split(line, " ")
      {bid, _} = bid_str |> Integer.parse()

      {String.graphemes(hand_str), bid}
    end)
  end

  def rank_hands(bet1, bet2) do
    {h1, _} = bet1
    {h2, _} = bet2
    c1 = classify_hand(h1)
    c2 = classify_hand(h2)

    if c1 == c2 do
      break_tie(h1, h2) <= 0
    else
      @hands[c1] <= @hands[c2]
    end
  end

  def classify_hand(hand) do
    frequencies = Enum.frequencies(hand)

    case Enum.count(frequencies) do
      5 ->
        :highcard

      4 ->
        :pair

      3 ->
        case Enum.max(Map.values(frequencies)) do
          3 -> :trips
          2 -> :twopair
        end

      2 ->
        case Enum.max(Map.values(frequencies)) do
          4 -> :quads
          3 -> :boat
        end

      1 ->
        :quints
    end
  end

  def break_tie(h1, h2) do
    Enum.zip(h1, h2)
    |> Enum.map(fn {c1, c2} ->
      v1 = @cards[c1]
      v2 = @cards[c2]

      v1 - v2
    end)
    |> Enum.find(fn val -> val != 0 end)
  end
end
