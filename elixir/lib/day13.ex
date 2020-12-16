defmodule Aoc.Day13 do
  @input "day13"

  def run_part1 do
    {timestamp, ids} = read_notes()

    {bus_id, earliest_depart} =
      ids
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer/1)
      |> Stream.map(fn id ->
        case rem(timestamp, id) do
          0 -> {id, timestamp}
          _ -> {id, (div(timestamp, id) + 1) * id}
        end
      end)
      |> Enum.min_by(&elem(&1, 1))

    bus_id * (earliest_depart - timestamp)
  end

  def run_part2 do
  end

  defp read_notes do
    [timestamp, ids] = Aoc.Input.read_lines(@input)

    {String.to_integer(timestamp), String.split(ids, ",")}
  end
end
