defmodule Aoc.Input do
  def read_lines(file_name) do
    file_name
    |> build_path()
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  def read_groups_of_lines(file_name) do
    file_name
    |> build_path()
    |> File.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
  end

  def stream_lines(file_name) do
    file_name
    |> build_path()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def stream_lines_characters(file_name) do
    file_name
    |> build_path()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.codepoints/1)
  end

  defp build_path(file_name) do
    "../_inputs/#{file_name}.txt"
  end
end
