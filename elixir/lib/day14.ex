defmodule Aoc.Day14 do
  @input "day14"
  @regex ~r/mem\[(?<address>\d+)\] = (?<value>\d+)/
  @bits Enum.map(35..0, &(:math.pow(2, &1) |> round()))

  def run_part1 do
    read_program()
    |> Enum.flat_map(fn {mask, instructions} ->
      Enum.map(instructions, fn {address, value} ->
        {address, value |> decimal_to_binary() |> apply_mask(mask, :v1) |> binary_to_decimal()}
      end)
    end)
    |> Enum.reduce(%{}, fn {address, value}, memory ->
      Map.put(memory, address, value)
    end)
    |> Map.values()
    |> Enum.reduce(0, &(&1 + &2))
  end

  def run_part2 do
    read_program()
    |> Enum.flat_map(fn {mask, instructions} ->
      Enum.flat_map(instructions, fn {address, value} ->
        address
        |> decimal_to_binary()
        |> apply_mask(mask, :v2)
        |> get_actual_addresses()
        |> Enum.map(&{&1, value})
      end)
    end)
    |> Enum.reduce(%{}, fn {address, value}, memory ->
      Map.put(memory, address, value)
    end)
    |> Map.values()
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp read_program do
    @input
    |> Aoc.Input.stream_lines()
    |> Enum.reduce([], fn
      "mask = " <> mask, acc ->
        [{mask, []} | acc]

      instruction, [{mask, instructions} | acc] ->
        %{"address" => address, "value" => value} = Regex.named_captures(@regex, instruction)

        instruction = {String.to_integer(address), String.to_integer(value)}

        [{mask, instructions ++ [instruction]} | acc]
    end)
    |> Enum.reverse()
  end

  defp decimal_to_binary(value) do
    @bits
    |> Enum.reduce({value, ""}, fn bit, {decimal, binary} ->
      if decimal >= bit do
        {rem(decimal, bit), binary <> "1"}
      else
        {decimal, binary <> "0"}
      end
    end)
    |> elem(1)
  end

  defp binary_to_decimal(value) do
    @bits
    |> Enum.reduce({value, 0}, fn
      bit_value, {"1" <> value, decimal} -> {value, decimal + bit_value}
      _bit_value, {"0" <> value, decimal} -> {value, decimal}
    end)
    |> elem(1)
  end

  defp apply_mask(value, mask, :v1), do: apply_mask_v1(value, mask, "")
  defp apply_mask(value, mask, :v2), do: apply_mask_v2(value, mask, "")

  defp apply_mask_v1("", "", result), do: result

  defp apply_mask_v1(<<bit::bytes-size(1)>> <> value, "X" <> mask, result),
    do: apply_mask_v1(value, mask, result <> bit)

  defp apply_mask_v1(<<_::bytes-size(1)>> <> value, <<bit::bytes-size(1)>> <> mask, result),
    do: apply_mask_v1(value, mask, result <> bit)

  defp apply_mask_v2("", "", result), do: result

  defp apply_mask_v2(<<bit::bytes-size(1)>> <> value, "0" <> mask, result),
    do: apply_mask_v2(value, mask, result <> bit)

  defp apply_mask_v2(<<_::bytes-size(1)>> <> value, <<bit::bytes-size(1)>> <> mask, result),
    do: apply_mask_v2(value, mask, result <> bit)

  defp get_actual_addresses(""), do: [""]

  defp get_actual_addresses("X" <> binary) do
    addresses = get_actual_addresses(binary)

    Enum.concat(Enum.map(addresses, &("0" <> &1)), Enum.map(addresses, &("1" <> &1)))
  end

  defp get_actual_addresses(<<bit::bytes-size(1)>> <> binary) do
    binary
    |> get_actual_addresses()
    |> Enum.map(&(bit <> &1))
  end
end
