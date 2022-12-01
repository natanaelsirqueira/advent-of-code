defmodule Aoc.Day18 do
  @input "day18"

  def run_part1, do: read_expressions() |> Stream.map(&run/1) |> Enum.reduce(&(&1 + &2))
  def run_part2, do: read_expressions() |> Stream.map(&run_advanced/1) |> Enum.reduce(&(&1 + &2))

  def run(expression), do: expression |> tokenize() |> parse() |> eval()
  def run_advanced(expression), do: expression |> tokenize() |> parse() |> advanced_eval()

  defp read_expressions(), do: Aoc.Input.stream_lines(@input)

  defp tokenize(expression), do: tokenize(expression, [])

  defp tokenize("", tokens), do: Enum.reverse(tokens)
  defp tokenize(" " <> exp, tokens), do: tokenize(exp, tokens)
  defp tokenize("+" <> exp, tokens), do: tokenize(exp, [{:op, :+} | tokens])
  defp tokenize("*" <> exp, tokens), do: tokenize(exp, [{:op, :*} | tokens])
  defp tokenize("(" <> exp, tokens), do: tokenize(exp, [:"(" | tokens])
  defp tokenize(")" <> exp, tokens), do: tokenize(exp, [:")" | tokens])

  defp tokenize(expression, tokens) do
    {num, rest} = Integer.parse(expression)

    tokenize(rest, [{:num, num} | tokens])
  end

  defp parse(tokens), do: parse(tokens, [], [])

  defp parse([], expression, _inner_expressions), do: expression

  defp parse([:"(" | tokens], expression, inner_expressions) do
    parse(tokens, expression, [{:exp, []} | inner_expressions])
  end

  defp parse([:")" | tokens], expression, [ended_inner_exp]) do
    parse(tokens, expression ++ [ended_inner_exp], [])
  end

  defp parse([:")" | tokens], expression, [ended_inner_exp, {:exp, exp} | inner_expressions]) do
    parse(tokens, expression, [{:exp, exp ++ [ended_inner_exp]} | inner_expressions])
  end

  defp parse([token | tokens], expression, [{:exp, exp} | inner_expressions]) do
    parse(tokens, expression, [{:exp, exp ++ [token]} | inner_expressions])
  end

  defp parse([token | tokens], expression, []) do
    parse(tokens, expression ++ [token], [])
  end

  defp eval([{:num, right}]), do: right

  defp eval([{:num, left}, {:op, op}, {:num, right} | tail]) do
    result = eval_operation(left, op, right)

    eval([{:num, result} | tail])
  end

  defp eval([{:num, left}, {:op, op}, {:exp, exp} | tail]) do
    result = eval_operation(left, op, eval(exp))

    eval([{:num, result} | tail])
  end

  defp eval([{:exp, exp} | tail]), do: eval([{:num, eval(exp)} | tail])

  defp advanced_eval([{:num, right}]), do: right

  defp advanced_eval([{:num, left}, {:op, :+}, {:num, right} | tail]) do
    advanced_eval([{:num, left + right} | tail])
  end

  defp advanced_eval([{:num, left}, {:op, :*} | tail]) do
    left * advanced_eval(tail)
  end

  defp advanced_eval([{:num, left}, {:op, op}, {:exp, exp} | tail]) do
    result = eval_operation(left, op, advanced_eval(exp))

    advanced_eval([{:num, result} | tail])
  end

  defp advanced_eval([{:exp, exp} | tail]), do: advanced_eval([{:num, advanced_eval(exp)} | tail])

  defp eval_operation(left, :+, right), do: left + right
  defp eval_operation(left, :*, right), do: left * right
end
