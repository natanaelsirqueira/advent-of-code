defmodule Aoc.Day11 do
  @input "day11"

  defmodule Part1 do
    def update_state(row, {column, state}, static_layout, {mutable_layout, changes}) do
      adjancent_seats_occupied =
        count_adjacent_seats_that_are_occupied(static_layout, row, column)

      {new_state, new_changes} =
        cond do
          state == :empty and adjancent_seats_occupied == 0 -> {:occupied, changes + 1}
          state == :occupied and adjancent_seats_occupied > 3 -> {:empty, changes + 1}
          true -> {state, changes}
        end

      {put_in(mutable_layout[row][column], new_state), new_changes}
    end

    defp count_adjacent_seats_that_are_occupied(current_state, row, column) do
      row
      |> get_adjacent_seats(column)
      |> Enum.count(&(get_in(current_state, &1) == :occupied))
    end

    defp get_adjacent_seats(row, column) do
      for x <- (row - 1)..(row + 1),
          y <- (column - 1)..(column + 1),
          {x, y} != {row, column},
          do: [x, y]
    end
  end

  defmodule Part2 do
    @rows 99
    @columns 99

    def update_state(row, {column, state}, static_layout, {mutable_layout, changes}) do
      first_seen_occupied_seats =
        count_occupied_seats_in_each_direction(static_layout, row, column)

      {new_state, new_changes} =
        cond do
          state == :empty and first_seen_occupied_seats == 0 -> {:occupied, changes + 1}
          state == :occupied and first_seen_occupied_seats > 4 -> {:empty, changes + 1}
          true -> {state, changes}
        end

      {put_in(mutable_layout[row][column], new_state), new_changes}
    end

    defp count_occupied_seats_in_each_direction(layout, row, col) do
      Enum.count(
        [
          :north,
          :south,
          :east,
          :west,
          :northwest,
          :northeast,
          :southwest,
          :southeast
        ],
        fn direction ->
          if seat = seats_in_direction(row, col, direction) |> find_first_seen_seat(layout) do
            seat == :occupied
          end
        end
      )
    end

    defp seats_in_direction(1, _col, :north), do: []

    defp seats_in_direction(row, col, :north) do
      Stream.zip((row - 1)..1, Stream.repeatedly(fn -> col end))
    end

    defp seats_in_direction(@rows, _col, :south), do: []

    defp seats_in_direction(row, col, :south) do
      Stream.zip((row + 1)..@columns, Stream.repeatedly(fn -> col end))
    end

    defp seats_in_direction(_row, 1, :east), do: []

    defp seats_in_direction(row, col, :east) do
      Stream.zip(Stream.repeatedly(fn -> row end), (col - 1)..1)
    end

    defp seats_in_direction(_row, @columns, :west), do: []

    defp seats_in_direction(row, col, :west) do
      Stream.zip(Stream.repeatedly(fn -> row end), (col + 1)..@columns)
    end

    defp seats_in_direction(1, _col, :northwest), do: []
    defp seats_in_direction(_row, 1, :northwest), do: []

    defp seats_in_direction(row, col, :northwest) do
      Stream.zip((row - 1)..1, (col - 1)..1)
    end

    defp seats_in_direction(1, _col, :northeast), do: []
    defp seats_in_direction(_row, @columns, :northeast), do: []

    defp seats_in_direction(row, col, :northeast) do
      Stream.zip((row - 1)..1, (col + 1)..@columns)
    end

    defp seats_in_direction(@rows, _col, :southwest), do: []
    defp seats_in_direction(_row, 1, :southwest), do: []

    defp seats_in_direction(row, col, :southwest) do
      Stream.zip((row + 1)..@rows, (col - 1)..1)
    end

    defp seats_in_direction(@rows, _col, :southeast), do: []
    defp seats_in_direction(_row, @columns, :southeast), do: []

    defp seats_in_direction(row, col, :southeast) do
      Stream.zip((row + 1)..@rows, (col + 1)..@columns)
    end

    defp find_first_seen_seat(positions, layout) do
      Enum.find_value(positions, fn {row, col} ->
        if layout[row][col] && layout[row][col] != :floor do
          layout[row][col]
        end
      end)
    end
  end

  def run_part1 do
    read_layout()
    |> apply_rules(Part1)
    |> count_occupied_seats()
  end

  def run_part2 do
    read_layout()
    |> apply_rules(Part2)
    |> count_occupied_seats()
  end

  defp read_layout do
    @input
    |> Aoc.Input.stream_lines()
    |> Stream.map(&String.codepoints/1)
    |> Stream.with_index(1)
    |> Enum.map(fn {row, row_index} ->
      row =
        row
        |> Enum.with_index(1)
        |> Enum.map(fn {col, col_index} ->
          {col_index, parse_state(col)}
        end)
        |> Map.new()

      {row_index, row}
    end)
    |> Map.new()
  end

  defp parse_state("L"), do: :empty
  defp parse_state("#"), do: :occupied
  defp parse_state("."), do: :floor

  defp apply_rules(layout, rule_set) do
    do_apply_rules(rule_set, Map.to_list(layout), layout, layout, _changes = 0)
  end

  defp do_apply_rules(_rule_set, [], _static_layout, layout, 0), do: layout

  defp do_apply_rules(rule_set, [], _static_layout, layout, _changes) do
    do_apply_rules(rule_set, Map.to_list(layout), layout, layout, 0)
  end

  defp do_apply_rules(rule_set, [{row, columns} | rows], static_layout, mutable_layout, changes) do
    {updated_layout, new_changes} =
      Enum.reduce(
        columns,
        {mutable_layout, _changes = 0},
        &rule_set.update_state(row, &1, static_layout, &2)
      )

    do_apply_rules(rule_set, rows, static_layout, updated_layout, changes + new_changes)
  end

  defp count_occupied_seats(rows) do
    rows
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.map(&elem(&1, 1))
    |> Enum.count(&(&1 == :occupied))
  end
end
