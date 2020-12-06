defmodule Aoc.Day4 do
  @required_fields ~w[byr iyr eyr hgt hcl ecl pid]a

  def run_part1 do
    read_input_and_parse_data()
    |> Stream.filter(fn passport ->
      Enum.all?(@required_fields, &Map.has_key?(passport, &1))
    end)
    |> Enum.count()
    |> IO.inspect
  end

  def run_part2 do
    read_input_and_parse_data()
    |> Stream.filter(&is_passport_valid?/1)
    |> Enum.count()
    |> IO.inspect
  end

  defp read_input_and_parse_data do
    "day4"
    |> Aoc.Input.read_groups_of_lines()
    |> Stream.map(&parse_passport/1)
  end

  defp parse_passport(line) do
    line
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(fn field ->
      [key, value] = String.split(field, ":")

      value =
        if key == "hgt" do
          {height, unit} = Integer.parse(value)

          %{value: height, unit: unit}
        else
          value
        end

      {String.to_atom(key), value}
    end)
    |> Map.new()
  end

  defp is_passport_valid?(passport) do
    validator = passport_validator()

    match?({:ok, _}, validator.(passport))
  end

  @compile {:inline, passport_validator: 0}
  defp passport_validator do
    import ExValidator

    map_of(%{
      byr: integer(required: true, min: 1920, max: 2002),
      iyr: integer(required: true, min: 2010, max: 2020),
      eyr: integer(required: true, min: 2020, max: 2030),
      hgt: any_of([
        map_of(%{
          unit: string(required: true, one_of: ["cm"]),
          value: integer(required: true, min: 150, max: 193)
        }),
        map_of(%{
          unit: string(required: true, one_of: ["in"]),
          value: integer(required: true, min: 59, max: 76)
        })
      ]),
      hcl: string(required: true, matches: ~r/^#([0-9a-f]{6})$/),
      ecl: string(required: true, one_of: ~w[amb blu brn gry grn hzl oth]),
      pid: string(required: true, matches: ~r/^\d{9}$/)
    })
  end
end
