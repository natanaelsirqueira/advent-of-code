defmodule AocTest do
  use ExUnit.Case

  test "day1" do
    assert Aoc.Day1.run_part1() == 567_171
    assert Aoc.Day1.run_part2() == 212_428_694
  end

  test "day2" do
    assert Aoc.Day2.run_part1() == 622
    assert Aoc.Day2.run_part2() == 263
  end

  test "day3" do
    assert Aoc.Day3.run_part1() == 220
    assert Aoc.Day3.run_part2() == 2_138_320_800
  end

  test "day4" do
    assert Aoc.Day4.run_part1() == 230
    assert Aoc.Day4.run_part2() == 156
  end

  test "day5" do
    assert Aoc.Day5.run_part1() == 801
    assert Aoc.Day5.run_part2() == 597
  end
end
