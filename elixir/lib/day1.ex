defmodule Aoc.Day1 do
  def run_part1 do
    "day1"
    |> Aoc.Input.read_lines()
    |> Enum.map(&String.to_integer/1)
    |> combinations(2)
    |> Enum.find(fn numbers ->
      Enum.reduce(numbers, &Kernel.+/2) == 2020
    end)
    |> Enum.reduce(&Kernel.*/2)
    |> IO.inspect
  end

  def run_part2 do
    "day1"
    |> Aoc.Input.read_lines()
    |> Enum.map(&String.to_integer/1)
    |> combinations(3)
    |> Enum.find(fn numbers ->
      Enum.reduce(numbers, &Kernel.+/2) == 2020
    end)
    |> Enum.reduce(&Kernel.*/2)
    |> IO.inspect
  end

  defp combinations([], _size), do: []
  defp combinations(_list, 0), do: [[]]

  defp combinations([head | tail], size) do
    tail
    |> combinations(size - 1)
    |> Enum.map(&[head | &1])
    |> Enum.concat(combinations(tail, size))
  end
end
