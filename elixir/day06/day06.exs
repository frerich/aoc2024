defmodule Day06 do
  def parse(input) do
    objects =
      for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
          {char, x} <- Enum.with_index(to_charlist(line)),
          char != ?. do
        {{x, y}, char}
      end

    lab = for {pos, ?#} <- objects, do: pos

    guard =
      Enum.find_value(objects, fn {pos, char} ->
        if char == ?^, do: pos
      end)

    {MapSet.new(lab), {guard, {0, -1}}}
  end

  def part_one(lab, guard) do
    lab
    |> path(guard)
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part_two(lab, guard) do
    {start, _dir} = guard

    visited = lab |> path(guard) |> Enum.map(fn {pos, _dir} -> pos end) |> Enum.uniq()

    Enum.count(visited -- [start], fn pos ->
      lab |> MapSet.put(pos) |> path_loop?(guard)
    end)
  end

  def path_loop?(lab, guard) do
    max_x = lab |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = lab |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    guard
    |> Stream.iterate(&step(lab, &1))
    |> Enum.reduce_while(MapSet.new(), fn guard, seen ->
      {{x, y}, _dir} = guard

      cond do
        MapSet.member?(seen, guard) -> {:halt, true}
        x not in 0..max_x or y not in 0..max_y -> {:halt, false}
        true -> {:cont, MapSet.put(seen, guard)}
      end
    end)
  end

  defp path(lab, guard) do
    max_x = lab |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = lab |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    guard
    |> Stream.iterate(&step(lab, &1))
    |> Enum.take_while(fn {{x, y}, _dir} ->
      x in 0..max_x and y in 0..max_y
    end)
  end

  defp step(lab, {{px, py}, {dx, dy}}) do
    {nx, ny} = {px + dx, py + dy}

    if MapSet.member?(lab, {nx, ny}) do
      {{px, py}, turn({dx, dy})}
    else
      {{nx, ny}, {dx, dy}}
    end
  end

  defp turn({0, -1}), do: {1, 0}
  defp turn({1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, -1}
end

{lab, guard} = Day06.parse(File.read!("input.txt"))
IO.puts(Day06.part_one(lab, guard))
IO.puts(Day06.part_two(lab, guard))
