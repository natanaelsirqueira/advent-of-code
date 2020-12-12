defmodule Aoc.Day2 do
  @input "day2"

  def run_part1 do
    @input
    |> Aoc.Input.stream_lines()
    |> Enum.filter(fn policy_and_password ->
      [policy, password] = String.split(policy_and_password, ":")
      [range, letter] = String.split(policy, " ")
      [min, max] = range |> String.split("-") |> Enum.map(&String.to_integer/1)

      count =
        password
        |> String.trim()
        |> String.split("")
        |> Enum.count(fn char ->
          char == letter
        end)

      count >= min and count <= max
    end)
    |> Enum.count()
  end

  def run_part2 do
    @input
    |> Aoc.Input.stream_lines()
    |> Enum.filter(fn policy_and_password ->
      [policy, password] = String.split(policy_and_password, ":")
      [range, letter] = String.split(policy, " ")
      [position1, position2] = range |> String.split("-") |> Enum.map(&String.to_integer/1)

      chars = password |> String.trim() |> String.split("") |> Enum.drop(1)

      char1 = Enum.at(chars, position1 - 1)
      char2 = Enum.at(chars, position2 - 1)

      Enum.count([char1, char2], &(&1 == letter)) == 1
    end)
    |> Enum.count()
  end
end
