defmodule Day07 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [result | values] = String.split(line, [":", " "], trim: true)
      {String.to_integer(result), Enum.map(values, &String.to_integer/1)}
    end)
  end

  def part_one(equations) do
    equations
    |> Enum.filter(fn equation -> solvable?(equation, [&+/2, &*/2]) end)
    |> Enum.map(fn {result, _values} -> result end)
    |> Enum.sum()
  end

  def part_two(equations) do
    equations
    |> Enum.filter(fn equation -> solvable?(equation, [&+/2, &*/2, &concat/2]) end)
    |> Enum.map(fn {result, _values} -> result end)
    |> Enum.sum()
  end

  def solvable?({result, values}, operators) do
    operators
    |> combinations(length(values) - 1)
    |> Enum.any?(fn ops ->
      [v | vs] = values
      Enum.zip_reduce(ops, vs, v, fn op, x, acc -> op.(acc, x) end) == result
    end)
  end

  def concat(x, y), do: x * 10 ** length(Integer.digits(y)) + y

  def combinations(_values, 0), do: [[]]

  def combinations(values, length) do
    for comb <- combinations(values, length - 1), value <- values do
      [value | comb]
    end
  end
end

equations = Day07.parse(File.read!("input.txt"))

IO.puts(Day07.part_one(equations))
IO.puts(Day07.part_two(equations))
