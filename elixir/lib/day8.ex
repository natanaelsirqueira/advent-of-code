defmodule Aoc.Day8 do
  @input "day8"

  def run_part1 do
    parse_instructions()
    |> execute([], 1, 0)
    |> elem(1)
    |> IO.inspect()
  end

  def run_part2 do
    instructions = parse_instructions()

    instructions
    |> Enum.reject(fn {_index, {instruction, _arg}} -> instruction == :acc end)
    |> Enum.reduce_while([], fn {index, {instruction, argument}}, _acc ->
      new_instruction = if instruction == :nop and argument != 0, do: :jmp, else: :nop

      instructions
      |> Map.replace!(index, {new_instruction, argument})
      |> execute([], 1, 0)
    end)
    |> IO.inspect()
  end

  defp parse_instructions do
    @input
    |> Aoc.Input.stream_lines()
    |> Stream.map(&String.split/1)
    |> Stream.with_index()
    |> Stream.map(fn {[instruction, argument], index} ->
      {index + 1, {:"#{instruction}", String.to_integer(argument)}}
    end)
    |> Map.new()
  end

  defp execute(instructions, instructions_executed, next_instruction, acc) do
    if next_instruction in instructions_executed do
      {:cont, acc}
    else
      instructions_executed = [next_instruction | instructions_executed]

      case instructions[next_instruction] do
        {:nop, _arg} ->
          execute(instructions, instructions_executed, next_instruction + 1, acc)

        {:acc, arg} ->
          execute(instructions, instructions_executed, next_instruction + 1, acc + arg)

        {:jmp, arg} ->
          execute(instructions, instructions_executed, next_instruction + arg, acc)

        nil ->
          {:halt, acc}
      end
    end
  end
end
