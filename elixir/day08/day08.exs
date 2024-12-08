defmodule Day08 do
  def parse(input) do
    lines = String.split(input, "\n", trim: true)

    width = String.length(hd(lines))
    height = Enum.count(lines)

    antennas =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(to_charlist(line)),
          char != ?. do
        {{x, y}, char}
      end

    antennas = Enum.group_by(antennas, fn {_pos, freq} -> freq end, fn {pos, _freq} -> pos end)

    {width, height, antennas}
  end

  def part_one({width, height, antennas}) do
    Enum.map(antennas, fn {_char, locations} ->
      pairs = locations |> pairs() |> Enum.sort_by(fn {_x, y} -> y end)

      for {{x0, y0}, {x1, y1}} <- pairs do
        {dx, dy} = {x1 - x0, y1 - y0}
        [{x0 - dx, y0 - dy}, {x1 + dx, y1 + dy}]
      end
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count(&in_bounds?(width, height, &1))
  end

  def part_two({width, height, antennas}) do
    Enum.map(antennas, fn {_char, locations} ->
      pairs = locations |> pairs() |> Enum.sort_by(fn {_x, y} -> y end)

      for {{x0, y0}, {x1, y1}} <- pairs do
        {dx, dy} = {x1 - x0, y1 - y0}
        naturals = Stream.iterate(0, &(&1 + 1))

        antinodes_top =
          naturals
          |> Stream.map(fn i -> {x0 - dx * i, y0 - dy * i} end)
          |> Stream.take_while(&in_bounds?(width, height, &1))

        antinodes_bottom =
          naturals
          |> Stream.map(fn i -> {x1 + dx * i, y1 + dy * i} end)
          |> Stream.take_while(&in_bounds?(width, height, &1))

        antinodes_top |> Stream.concat(antinodes_bottom) |> Enum.to_list()
      end
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def pairs([]), do: []
  def pairs([x | xs]), do: Enum.map(xs, &{x, &1}) ++ pairs(xs)

  def in_bounds?(width, height, {x, y}) do
    x in 0..(width - 1) and y in 0..(height - 1)
  end
end

map = Day08.parse(File.read!("input.txt"))
IO.puts(Day08.part_one(map))
IO.puts(Day08.part_two(map))
