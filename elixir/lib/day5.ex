defmodule Aoc.Day5 do
  def run_part1 do
    calculate_seats_ids()
    |> Enum.max()
    |> IO.inspect()
  end

  def run_part2 do
    ids = Enum.sort(calculate_seats_ids())

    ids
    |> Enum.reduce_while(List.first(ids), fn id, last_id ->
      if id - last_id <= 1 do
        {:cont, id}
      else
        {:halt, last_id + 1}
      end
    end)
    |> IO.inspect()
  end

  defp calculate_seats_ids do
    "day5"
    |> Aoc.Input.stream_lines_characters()
    |> Enum.map(fn boarding_pass ->
      {row_config, column_config} = Enum.split(boarding_pass, 7)

      row =
        row_config
        |> Enum.reduce(0..127, fn char, first..last ->
          half = div(last + 1 - first, 2)

          case char do
            "F" -> first..(first + half - 1)
            "B" -> (first + half)..last
          end
        end)
        |> Enum.to_list()
        |> List.first()

      column =
        column_config
        |> Enum.reduce(0..7, fn char, first..last ->
          half = div(last + 1 - first, 2)

          case char do
            "L" -> first..(first + half - 1)
            "R" -> (first + half)..last
          end
        end)
        |> Enum.to_list()
        |> List.first()

      row * 8 + column
    end)
  end
end
