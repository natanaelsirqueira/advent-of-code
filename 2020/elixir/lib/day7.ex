defmodule Aoc.Day7 do
  @input "day7"
  @target "shiny gold"

  def run_part1 do
    known_bags = parse_bags()

    known_bags
    |> Enum.reduce(0, fn {_color, bags}, amount ->
      if lead_to_target?(bags, @target, known_bags), do: amount + 1, else: amount
    end)
    |> IO.inspect()
  end

  def run_part2 do
    known_bags = parse_bags()

    IO.inspect count_bags(known_bags[@target], known_bags)
  end

  defp lead_to_target?(bags, target, known_bags) do
    colors = Map.keys(bags)

    target in colors or
      Enum.any?(colors, &lead_to_target?(known_bags[&1], target, known_bags))
  end

  defp count_bags(bags, known_bags) do
    Enum.reduce(bags, 0, fn {color, quantity}, amount ->
      chained_bags = Map.fetch!(known_bags, color)

      amount + quantity + quantity * count_bags(chained_bags, known_bags)
    end)
  end

  defp parse_bags do
    @input
    |> Aoc.Input.stream_lines()
    |> Stream.map(fn line ->
      [color, children] = String.split(line, " bags contain ")

      children =
        children
        |> String.split(", ")
        |> Stream.map(&String.replace(&1, ~r/bags|bag|\./, ""))
        |> Stream.map(&Integer.parse(&1))
        |> Stream.reject(&(&1 == :error))
        |> Stream.map(fn {quantity, bag_color} -> {String.trim(bag_color), quantity} end)
        |> Map.new()

      {color, children}
    end)
    |> Map.new()
  end
end
