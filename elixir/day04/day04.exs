defmodule Day04 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {char, x} <- Enum.with_index(to_charlist(line)),
        into: %{} do
      {{x, y}, char}
    end
  end

  def part_one(puzzle) do
    for {{x, y}, ?X} <- puzzle do
      # Paths in which the word 'MAS' may occur, starting from an X.
      directions = [
        [{x, y - 1}, {x, y - 2}, {x, y - 3}],
        [{x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}],
        [{x + 1, y}, {x + 2, y}, {x + 3, y}],
        [{x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}],
        [{x, y + 1}, {x, y + 2}, {x, y + 3}],
        [{x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}],
        [{x - 1, y}, {x - 2, y}, {x - 3, y}],
        [{x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3}]
      ]

      Enum.count(directions, fn direction ->
        Enum.map(direction, &puzzle[&1]) == ~c"MAS"
      end)
    end
    |> Enum.sum()
  end

  def part_two(puzzle) do
    for {{x, y}, ?A} <- puzzle do
      # Patterns in which the letters 'MMSS' may appear around an A.
      patterns = [
        [{x - 1, y - 1}, {x + 1, y - 1}, {x - 1, y + 1}, {x + 1, y + 1}],
        [{x + 1, y - 1}, {x + 1, y + 1}, {x - 1, y - 1}, {x - 1, y + 1}],
        [{x - 1, y + 1}, {x + 1, y + 1}, {x - 1, y - 1}, {x + 1, y - 1}],
        [{x - 1, y - 1}, {x - 1, y + 1}, {x + 1, y - 1}, {x + 1, y + 1}]
      ]

      Enum.any?(patterns, fn pattern ->
        Enum.map(pattern, &puzzle[&1]) == ~c"MMSS"
      end)
    end
    |> Enum.count(& &1)
  end
end

puzzle = Day04.parse(File.read!("input.txt"))
IO.puts(Day04.part_one(puzzle))
IO.puts(Day04.part_two(puzzle))
