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

  test "day6" do
    assert Aoc.Day6.run_part1() == 6735
    assert Aoc.Day6.run_part2() == 3221
  end

  test "day7" do
    assert Aoc.Day7.run_part1() == 148
    assert Aoc.Day7.run_part2() == 24867
  end

  test "day8" do
    assert Aoc.Day8.run_part1() == 1331
    assert Aoc.Day8.run_part2() == 1121
  end

  test "day9" do
    assert Aoc.Day9.run_part1() == 27911108
    assert Aoc.Day9.run_part2() == 4023754
  end

  test "day10" do
    assert Aoc.Day10.run_part1() == 1690
    assert Aoc.Day10.run_part2() == 5289227976704
  end

  # test "day11" do
  #   assert Aoc.Day11.run_part1() == 2483
  #   assert Aoc.Day11.run_part2() == 2285
  # end

  test "day12" do
    assert Aoc.Day12.run_part1() == 2297
    assert Aoc.Day12.run_part2() == 89984
  end

  test "day13" do
    assert Aoc.Day13.run_part1() == 3865
    assert Aoc.Day13.run_part2() == 0
  end

  test "day14" do
    assert Aoc.Day14.run_part1() == 6631883285184
    assert Aoc.Day14.run_part2() == 3161838538691
  end

  # test "day15" do
  #   assert Aoc.Day15.run_part1() == 929
  #   assert Aoc.Day15.run_part2() == 16671510
  # end

  test "day16" do
    assert Aoc.Day16.run_part1() == 26053
    assert Aoc.Day16.run_part2() == 1515506256421
  end
end
