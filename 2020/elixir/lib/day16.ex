defmodule Aoc.Day16 do
  @input "day16"

  @field_rule_regex ~r/^(?<name>.+)\: (?<range1>\d+-\d+) or (?<range2>\d+-\d+)$/

  def run_part1 do
    {fields_rules, _my_ticket, nearby_tickets} = read_notes()

    nearby_tickets
    |> Enum.flat_map(& &1)
    |> Enum.reduce(0, fn ticket_field_value, sum ->
      if is_field_valid?(ticket_field_value, fields_rules) do
        sum
      else
        sum + ticket_field_value
      end
    end)
  end

  def run_part2 do
    {fields_rules, my_ticket, nearby_tickets} = read_notes()

    fields_by_index =
      fields_rules
      |> map_rules_to_all_indexes_that_contain_only_valid_values(nearby_tickets)
      |> map_each_index_to_a_single_matching_field()

    my_ticket
    |> Enum.with_index()
    |> Enum.flat_map(fn {value, index} ->
      if String.starts_with?(fields_by_index[index], "departure"), do: [value], else: []
    end)
    |> Enum.reduce(&(&1 * &2))
  end

  defp map_rules_to_all_indexes_that_contain_only_valid_values(rules, nearby_tickets) do
    tickets_values_by_field_index =
      nearby_tickets
      |> Enum.filter(&are_all_valid?(&1, rules))
      |> Enum.flat_map(&Enum.with_index/1)
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))

    Enum.map(rules, fn field_rule ->
      indexes =
        Enum.flat_map(tickets_values_by_field_index, fn {field_index, tickets_values} ->
          if Enum.all?(tickets_values, &is_field_valid?(&1, field_rule)),
            do: [field_index],
            else: []
        end)

      {field_rule.name, indexes}
    end)
  end

  defp map_each_index_to_a_single_matching_field(indexes_by_rules) do
    indexes_by_rules
    |> Enum.sort_by(&length(elem(&1, 1)))
    |> Enum.reduce({[], []}, fn {field_name, matching_indexes},
                                {fields_by_index, indexes_already_taken} ->
      [field_index] = matching_indexes -- indexes_already_taken

      {[{field_index, field_name} | fields_by_index], [field_index | indexes_already_taken]}
    end)
    |> elem(0)
    |> Map.new()
  end

  defp read_notes do
    [fields, [_, my_ticket], [_ | nearby_tickets]] = Aoc.Input.read_groups_of_lines(@input)

    {parse_fields(fields), parse_ticket(my_ticket), Enum.map(nearby_tickets, &parse_ticket/1)}
  end

  defp parse_fields(fields) do
    Enum.map(fields, fn field ->
      @field_rule_regex
      |> Regex.named_captures(field)
      |> Map.new(fn
        {"name", name} -> {:name, name}
        {"range" <> which, range} -> {:"range#{which}", parse_range(range)}
      end)
    end)
  end

  defp parse_range(range) do
    [first, last] = String.split(range, "-")

    Range.new(String.to_integer(first), String.to_integer(last))
  end

  defp parse_ticket(ticket) do
    ticket |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  defp are_all_valid?(ticket_values, fields_rules) do
    Enum.all?(ticket_values, &is_field_valid?(&1, fields_rules))
  end

  defp is_field_valid?(field_value, rules) when is_list(rules) do
    Enum.any?(rules, &(field_value in &1.range1 or field_value in &1.range2))
  end

  defp is_field_valid?(value, rule), do: value in rule.range1 or value in rule.range2
end
