defmodule Aoc.Day17 do
  @input "day17"

  def run_part1 do
    read_cubes()
    |> Enum.map(fn {x, y} -> {x, y, 0} end)
    |> run_cycles()
    |> length()
  end

  def run_part2 do
    read_cubes()
    |> Enum.map(fn {x, y} -> {x, y, 0, 0} end)
    |> run_cycles()
    |> length()
  end

  defp read_cubes do
    @input
    |> Aoc.Input.stream_lines()
    |> Stream.map(&String.codepoints/1)
    |> Stream.with_index(0)
    |> Enum.flat_map(fn {row, x} ->
      row
      |> Enum.with_index(0)
      |> Enum.flat_map(fn {col, col_index} ->
        if col == "#", do: [col_index], else: []
      end)
      |> Enum.map(fn y -> {x, y} end)
    end)
  end

  defp run_cycles(active_cubes) do
    Enum.reduce(1..6, active_cubes, fn _n, active_cubes ->
      {new_active_cubes, inactive_cubes} = apply_rules(active_cubes, active_cubes, [], %{})

      Enum.reduce(inactive_cubes, new_active_cubes, fn {inactive_cube, active_neighbors_count},
                                                       new_active_cubes ->
        if active_neighbors_count == 3 do
          [inactive_cube | new_active_cubes]
        else
          new_active_cubes
        end
      end)
    end)
  end

  defp apply_rules([], _, new_active_cubes, inactive_cubes),
    do: {new_active_cubes, inactive_cubes}

  defp apply_rules([cube | rest], active_cubes, new_active_cubes, inactive_cubes) do
    {active_neighbors_count, new_inactive_cubes} =
      cube
      |> get_neighboors()
      |> Enum.reduce({0, inactive_cubes}, fn neighbor, {active_neighbors, inactive_neighbors} ->
        if neighbor in active_cubes do
          {active_neighbors + 1, inactive_neighbors}
        else
          {active_neighbors, Map.update(inactive_neighbors, neighbor, 1, &(&1 + 1))}
        end
      end)

    new_active_cubes =
      if active_neighbors_count in [2, 3], do: [cube | new_active_cubes], else: new_active_cubes

    apply_rules(rest, active_cubes, new_active_cubes, new_inactive_cubes)
  end

  def get_neighboors({row, column, third_dimension}) do
    for x <- (row - 1)..(row + 1),
        y <- (column - 1)..(column + 1),
        z <- (third_dimension - 1)..(third_dimension + 1),
        {x, y, z} != {row, column, third_dimension},
        do: {x, y, z}
  end

  def get_neighboors({row, column, third_dimension, fourth_dimension}) do
    for x <- (row - 1)..(row + 1),
        y <- (column - 1)..(column + 1),
        z <- (third_dimension - 1)..(third_dimension + 1),
        w <- (fourth_dimension - 1)..(fourth_dimension + 1),
        {x, y, z, w} != {row, column, third_dimension, fourth_dimension},
        do: {x, y, z, w}
  end
end
