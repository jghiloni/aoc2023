defmodule Day1 do
  def part1(filename) do
    filename |> File.stream! |> Enum.map(&String.trim/1) \
      |> Enum.map(&Day1.reveal_number/1) \
      |> Enum.reduce(0, fn prev, next -> prev + next end)
  end

  def reveal_number("") do 0 end
  def reveal_number(line) do
    numCharList = to_charlist(line) |> Enum.filter(fn g -> Enum.member?(~c"1234567890", g) end)
    {num, _rem} = List.to_string(Enum.take(numCharList,1)) <> List.to_string(Enum.take(numCharList, -1)) |> Integer.parse()
    num
  end
end
