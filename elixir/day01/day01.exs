defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [left, right] = String.split(line)
      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.unzip()
  end

  def part1({left, right}) do
    Enum.zip(Enum.sort(left), Enum.sort(right))
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2({left, right}) do
    left
    |> Enum.map(fn number ->
      number * Enum.count(right, & &1 == number)
    end)
    |> Enum.sum()
  end
end

input = Day01.parse(File.read!("input.txt"))
IO.puts(Day01.part1(input))
IO.puts(Day01.part2(input))
