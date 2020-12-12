defmodule Aoc.Day9 do
  @input "day9"
  @preamble_size 25

  def run_part1 do
    read_numbers()
    |> find_invalid_number()
    |> IO.inspect()
  end

  def run_part2 do
    numbers = read_numbers()
    target = find_invalid_number(numbers)

    ordered_set =
      numbers
      |> Enum.reduce_while({[], 0}, fn number, {set, acc} ->
        new_set = set ++ [number]
        new_acc = acc + number

        cond do
          new_acc < target ->
            {:cont, {new_set, new_acc}}

          new_acc == target ->
            {:halt, new_set}

          new_acc > target ->
            case drop_until_consumes(new_set, new_acc, target) do
              {set, ^target} -> {:halt, set}
              new_state -> {:cont, new_state}
            end
        end
      end)
      |> Enum.sort()

    IO.inspect(List.first(ordered_set) + List.last(ordered_set))
  end

  defp find_invalid_number(numbers) do
    numbers
    |> Stream.drop(@preamble_size)
    |> Enum.reduce_while(Enum.take(numbers, @preamble_size), fn number, preamble ->
      preamble
      |> Enum.split_with(&(&1 < number))
      |> elem(0)
      |> permutations()
      |> Enum.any?(&(Enum.sum(&1) == number))
      |> case do
        true -> {:cont, Enum.drop(preamble, 1) ++ [number]}
        false -> {:halt, number}
      end
    end)
  end

  defp read_numbers do
    @input |> Aoc.Input.stream_lines() |> Stream.map(&String.to_integer/1)
  end

  defp permutations(enumerable) do
    for x <- enumerable, y <- enumerable, x != y, do: [x, y]
  end

  defp drop_until_consumes([], acc, _target), do: {[], acc}
  defp drop_until_consumes(list, acc, target) when acc <= target, do: {list, acc}

  defp drop_until_consumes([head | tail], acc, target) do
    drop_until_consumes(tail, acc - head, target)
  end
end
