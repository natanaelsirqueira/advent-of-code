defmodule Aoc.Day12 do
  @input "day12"

  def run_part1 do
    state = {%{latitude: 0, longitude: 0}, :east}

    {ship, _} =
      Enum.reduce(read_instructions(), state, fn instruction, {ship, direction} ->
        case parse_instruction(instruction) do
          {"F", units} -> {move_ship(ship, direction, units), direction}
          {"N", units} -> {move_ship(ship, :north, units), direction}
          {"S", units} -> {move_ship(ship, :south, units), direction}
          {"E", units} -> {move_ship(ship, :east, units), direction}
          {"W", units} -> {move_ship(ship, :west, units), direction}
          {"L", degrees} -> {ship, rotate_left(direction, degrees)}
          {"R", degrees} -> {ship, rotate_right(direction, degrees)}
        end
      end)

    abs(ship.latitude) + abs(ship.longitude)
  end

  def run_part2 do
    state = {%{latitude: 0, longitude: 0}, %{north: 1, east: 10}}

    {ship, _} =
      Enum.reduce(read_instructions(), state, fn instruction, {ship, waypoint} ->
        case parse_instruction(instruction) do
          {"F", multiplier} -> {move_ship_to_waypoint(ship, waypoint, multiplier), waypoint}
          {"N", units} -> {ship, move_waypoint(waypoint, :north, units)}
          {"S", units} -> {ship, move_waypoint(waypoint, :south, units)}
          {"E", units} -> {ship, move_waypoint(waypoint, :east, units)}
          {"W", units} -> {ship, move_waypoint(waypoint, :west, units)}
          {"L", degrees} -> {ship, rotate_waypoint(waypoint, degrees, &rotate_left/2)}
          {"R", degrees} -> {ship, rotate_waypoint(waypoint, degrees, &rotate_right/2)}
        end
      end)

    abs(ship.latitude) + abs(ship.longitude)
  end

  defp read_instructions, do: Aoc.Input.stream_lines(@input)

  defp parse_instruction(<<action::bytes-size(1)>> <> value),
    do: {action, String.to_integer(value)}

  defp move_ship(position, :north, units), do: Map.update!(position, :latitude, &(&1 + units))
  defp move_ship(position, :south, units), do: Map.update!(position, :latitude, &(&1 - units))
  defp move_ship(position, :east, units), do: Map.update!(position, :longitude, &(&1 + units))
  defp move_ship(position, :west, units), do: Map.update!(position, :longitude, &(&1 - units))

  defp move_ship_to_waypoint(ship, waypoint, multiplier) do
    Enum.reduce(waypoint, ship, fn {direction, units}, ship ->
      move_ship(ship, direction, units * multiplier)
    end)
  end

  defp move_waypoint(waypoint, direction, units) do
    if Map.has_key?(waypoint, direction) do
      Map.update!(waypoint, direction, &(&1 + units))
    else
      opposite_direction = get_opposite_direction(direction)

      new_position = waypoint[opposite_direction] - units

      if new_position >= 0 do
        Map.replace!(waypoint, opposite_direction, new_position)
      else
        waypoint
        |> Map.delete(opposite_direction)
        |> Map.put_new(direction, abs(new_position))
      end
    end
  end

  defp get_opposite_direction(:north), do: :south
  defp get_opposite_direction(:south), do: :north
  defp get_opposite_direction(:east), do: :west
  defp get_opposite_direction(:west), do: :east

  defp rotate_waypoint(waypoint, degrees, rotate_fun) do
    [{direction1, units1}, {direction2, units2}] = Map.to_list(waypoint)

    %{
      rotate_fun.(direction1, degrees) => units1,
      rotate_fun.(direction2, degrees) => units2
    }
  end

  defp rotate_left(current_direction, degrees),
    do: rotate([:north, :west, :south, :east], current_direction, degrees)

  defp rotate_right(current_direction, degrees),
    do: rotate([:east, :south, :west, :north], current_direction, degrees)

  defp rotate(directions, current_direction, degrees) do
    directions
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 != current_direction))
    |> Stream.drop(div(degrees, 90))
    |> Enum.take(1)
    |> List.first()
  end
end
