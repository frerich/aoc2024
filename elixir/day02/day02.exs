defmodule Day02 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      line |> String.split() |> Enum.map(&String.to_integer/1)
    end
  end

  def part_one(reports) do
    Enum.count(reports, &safe?/1)
  end

  def part_two(reports) do
    Enum.count(reports, fn report ->
      variants = for i <- 0..length(report), do: List.delete_at(report, i)
      Enum.any?(variants, &safe?/1)
    end)
  end

  def safe?(report) do
    [{l0, l1} | _] = pairs = Enum.zip(report, tl(report))
    first_sign = sign(l0, l1)

    Enum.all?(pairs, fn {l0, l1} ->
      sign(l0, l1) == first_sign and abs(l0 - l1) in 1..3
    end)
  end

  defp sign(a, b) when a < b, do: -1
  defp sign(a, b) when a > b, do: 1
  defp sign(_, _), do: 0
end

reports = Day02.parse(File.read!("input.txt"))

IO.puts(Day02.part_one(reports))
IO.puts(Day02.part_two(reports))
