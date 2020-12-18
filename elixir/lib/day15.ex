defmodule Aoc.Day15 do
  defmodule Solution do
    defmacro __using__(_opts) do
      quote do
        def run(numbers) do
          run(numbers, 1, %{})
        end

        defp run([next_number | rest], turn, state) when rest != [] do
          run(rest, turn + 1, Map.put(state, next_number, turn))
        end

        defp run([next_number], turn, state) do
          run(turn + 1, 0, Map.put(state, next_number, turn))
        end

        defp run(@target, next_number, _state), do: next_number

        defp run(turn, next_number, state) do
          case Map.get(state, next_number) do
            nil ->
              run(turn + 1, 0, Map.put(state, next_number, turn))

            last_spoken ->
              run(turn + 1, turn - last_spoken, Map.put(state, next_number, turn))
          end
        end
      end
    end
  end

  defmodule Part1 do
    @target 2020
    use Solution
  end

  defmodule Part2 do
    @target 30_000_000
    use Solution
  end

  def run_part1, do: Part1.run([16, 1, 0, 18, 12, 14, 19])
  def run_part2, do: Part2.run([16, 1, 0, 18, 12, 14, 19])
end
