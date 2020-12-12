defmodule Aoc.Day5 do
  @input "day5"

  def run_part1 do
    calculate_seats_ids()
    |> Enum.max()
    |> IO.inspect()
  end

  def run_part2 do
    ids = Enum.sort(calculate_seats_ids())

    ids
    |> Enum.reduce_while(hd(ids), fn id, last_id ->
      if id - last_id > 1 do
        {:halt, last_id + 1}
      else
        {:cont, id}
      end
    end)
    |> IO.inspect()
  end

  defp calculate_seats_ids do
    @input
    |> Aoc.Input.stream_lines_characters()
    |> Enum.map(fn boarding_pass ->
      {row_config, column_config} = Enum.split(boarding_pass, 7)

      row = calculate(row_config, "B")
      column = calculate(column_config, "R")

      row * 8 + column
    end)
  end

  defp calculate(chars, truthy_char) do
    chars
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.filter(&elem(&1, 0) == truthy_char)
    |> Enum.reduce(0, fn {_, index}, acc -> acc + :math.pow(2, index) |> round() end)
  end
end
