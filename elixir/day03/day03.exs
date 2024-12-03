defmodule Day04 do
  def part_one(memory) do
    muls = Regex.scan(~r/mul\(\d+,\d+\)/, memory)

    Enum.map(muls, fn [inst] ->
      ["mul", a, b] = String.split(inst, ["(", ",", ")"], trim: true)
      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end

  def part_two(memory) do
    instructions = Regex.scan(~r/mul\(\d+,\d+\)|do\(\)|don't\(\)/, memory)

    {sum, _enabled?} =
      Enum.reduce(instructions, {0, true}, fn
        [<<"mul", _::binary>> = inst], {sum, true} ->
          ["mul", a, b] = String.split(inst, ["(", ",", ")"], trim: true)
          {sum + String.to_integer(a) * String.to_integer(b), true}

        [<<"mul", _::binary>> = _inst], {sum, enabled?} ->
          {sum, enabled?}

        ["do()"], {sum, _enabled?} ->
          {sum, true}

        ["don't()"], {sum, _enabled?} ->
          {sum, false}
      end)

    sum
  end
end

memory = File.read!("input.txt")
IO.puts(Day04.part_one(memory))
IO.puts(Day04.part_two(memory))
