defmodule Day09 do
  def parse(input) do
    {integer, ""} = Integer.parse(input)
    [digit | digits] = Integer.digits(integer)

    arr = :array.new()

    arr =
      Enum.reduce(0..(digit - 1), arr, fn i, arr ->
        :array.set(i, 0, arr)
      end)

    {arr, _pos} =
      digits
      |> Enum.chunk_every(2)
      |> Enum.with_index(1)
      |> Enum.reduce({arr, digit}, fn {[gap, len], file_idx}, {arr, pos} ->
        arr =
          Enum.reduce(0..(len - 1), arr, fn i, arr ->
            :array.set(pos + gap + i, file_idx, arr)
          end)

        {arr, pos + gap + len}
      end)

    arr
  end

  def part_one(disk_map) do
    compacted = compact(disk_map, 0)
    checksum(compacted)
  end

  def checksum(disk_map) do
    disk_map
    |> :array.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {file_id, position} -> file_id * position end)
    |> Enum.sum()
  end

  def compact(disk_map, write_pos) do
    size = :array.size(disk_map)

    cond do
      write_pos >= size ->
        disk_map

      :array.get(write_pos, disk_map) != :undefined ->
        compact(disk_map, write_pos + 1)

      true ->
        block = :array.get(size - 1, disk_map)
        disk_map = :array.set(write_pos, block, disk_map)

        new_size =
          Enum.find((size - 2)..write_pos//-1, fn i -> :array.get(i, disk_map) != :undefined end)

        if new_size do
          disk_map = :array.resize(new_size + 1, disk_map)
          compact(disk_map, write_pos + 1)
        else
          disk_map
        end
    end
  end

  def print(disk_map) do
    disk_map
    |> :array.to_list()
    |> Enum.map(fn
      :undefined -> IO.write(".")
      digit -> IO.write(digit)
    end)

    IO.write("\n")
  end
end

disk_map = Day09.parse(File.read!("input.txt") |> String.trim())
IO.puts(Day09.part_one(disk_map))
