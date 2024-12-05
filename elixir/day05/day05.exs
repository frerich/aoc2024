defmodule Day05 do
  def parse(input) do
    [section1, section2] = String.split(input, "\n\n", trim: true)

    rules =
      for line <- String.split(section1, "\n") do
        [a, b] = String.split(line, "|")
        {String.to_integer(a), String.to_integer(b)}
      end

    updates =
      for line <- String.split(section2, "\n", trim: true) do
        line |> String.split(",") |> Enum.map(&String.to_integer/1)
      end

    {rules, updates}
  end

  def part_one(rules, updates) do
    updates
    |> Enum.filter(&(&1 == sorted(&1, rules)))
    |> Enum.map(&middle(&1))
    |> Enum.sum()
  end

  def part_two(rules, updates) do
    updates
    |> Enum.reject(&(&1 == sorted(&1, rules)))
    |> Enum.map(&middle(sorted(&1, rules)))
    |> Enum.sum()
  end

  defp sorted(update, rules) do
    Enum.sort(update, fn a, b -> {a, b} in rules end)
  end

  defp middle(list) do
    Enum.at(list, div(length(list), 2))
  end
end

{rules, updates} = Day05.parse(File.read!("input.txt"))
IO.puts(Day05.part_one(rules, updates))
IO.puts(Day05.part_two(rules, updates))
