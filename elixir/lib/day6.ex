defmodule Aoc.Day6 do
  @input "day6"

  def run_part1 do
    @input
    |> Aoc.Input.read_groups_of_lines()
    |> Enum.map(fn group ->
      group
      |> Enum.flat_map(&String.codepoints/1)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.reduce(&Kernel.+/2)
    |> IO.inspect
  end

  def run_part2 do
    @input
    |> Aoc.Input.read_groups_of_lines()
    |> Enum.map(fn group ->
      group
      |> Enum.map(&String.codepoints/1)
      |> Enum.reduce(fn person_answers, common_answers ->
        person_answers
        |> MapSet.new()
        |> MapSet.intersection(MapSet.new(common_answers))
      end)
      |> Enum.to_list()
      |> Enum.count()
    end)
    |> Enum.reduce(&Kernel.+/2)
    |> IO.inspect
  end
end
