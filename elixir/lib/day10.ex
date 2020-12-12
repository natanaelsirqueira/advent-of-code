defmodule Aoc.Day10 do
  @input "day10"

  def run_part1 do
    {diff1, diff3} = calc_differences(read_adapters(), 0, 0, 0)

    diff1 * (diff3 + 1)
  end

  def run_part2 do
    [0 | read_adapters()]
    |> Enum.reverse()
    |> count_arrangements([], %{})
  end

  defp read_adapters do
    @input
    |> Aoc.Input.stream_lines()
    |> Stream.map(&String.to_integer/1)
    |> Enum.sort()
  end

  defp calc_differences([], _highest_adapter, diff1, diff3), do: {diff1, diff3}

  defp calc_differences([next_adapter | adapters], previous_adapter, diff1, diff3) do
    case next_adapter - previous_adapter do
      1 -> calc_differences(adapters, next_adapter, diff1 + 1, diff3)
      3 -> calc_differences(adapters, next_adapter, diff1, diff3 + 1)
    end
  end

  defp count_arrangements([], [head | _], lookup), do: lookup[head]

  defp count_arrangements([head | tail], next_adapters, lookup) do
    if next_adapters == [] do
      count_arrangements(tail, [head], Map.put(lookup, head, 1))
    else
      arrangements_count =
        Enum.reduce_while(next_adapters, 0, fn adapter, count ->
          if adapter <= head + 3, do: {:cont, count + lookup[adapter]}, else: {:halt, count}
        end)

      count_arrangements(tail, [head | next_adapters], Map.put(lookup, head, arrangements_count))
    end
  end
end
