use std::ops::RangeInclusive;
use itertools::sorted;

use super::utils;

pub fn run_part1() -> i32 {
  let result = calculate_seats_ids().max().unwrap();

  println!("{}", result);

  result
}

pub fn run_part2() -> i32 {
  let ids: Vec<i32> = sorted(calculate_seats_ids()).collect();

  let mut result = ids[0];

  for id in ids {
    if id - result > 1 {
      result += 1;
      break;
    }

    result = id;
  }

  println!("{}", result);

  result
}

fn calculate_seats_ids() -> impl Iterator<Item = i32> {
  utils::file::read_lines("../_inputs/day5.txt")
    .map(|line| {
      let (row_config, column_config) = line.split_at(7);

      let row = row_config
        .chars()
        .fold(RangeInclusive::new(0, 127), |range, letter| {
          let half = (range.end() + 1 - range.start()) / 2;

          match letter {
            'F' => RangeInclusive::new(*range.start(), range.start() + half - 1),
            'B' => RangeInclusive::new(range.start() + half, *range.end()),
            _ => range
          }
        });

      let column = column_config
        .chars()
        .fold(RangeInclusive::new(0, 7), |range, letter| {
          let half = (range.end() + 1 - range.start()) / 2;

          match letter {
            'L' => RangeInclusive::new(*range.start(), range.start() + half - 1),
            'R' => RangeInclusive::new(range.start() + half, *range.end()),
            _ => range
          }
        });

      row.start() * 8 + column.start()
    })
}
