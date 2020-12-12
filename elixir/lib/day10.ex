defmodule Aoc.Day10 do
  @input "day10-example2"

  def run_part1 do
    read_adapters()
    |> differences_product(0, 0, 0)
    |> IO.inspect()
  end

  def run_part2 do
    read_adapters()
    |> List.insert_at(0, 0)
    |> Enum.reverse()
    |> count_arrangements([], %{})
    |> IO.inspect()
  end

  defp read_adapters do
    @input
    |> Aoc.Input.stream_lines()
    |> Stream.map(&String.to_integer/1)
    |> Enum.sort()
  end

  defp differences_product([], _highest_adapter, diff1, diff3), do: diff1 * (diff3 + 1)

  defp differences_product(adapters, accumulated_joltage, diff1, diff3) do
    {matching_adapters, rest} = Enum.split_while(adapters, &(&1 <= accumulated_joltage + 3))

    [next_adapter | other_matching_adapters] = Enum.sort(matching_adapters)

    case next_adapter - accumulated_joltage do
      1 -> differences_product(other_matching_adapters ++ rest, next_adapter, diff1 + 1, diff3)
      3 -> differences_product(other_matching_adapters ++ rest, next_adapter, diff1, diff3 + 1)
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
