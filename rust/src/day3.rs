use std::iter;

use super::utils;

pub fn run_part1() -> usize {
  let run_part2 = count_trees(3, 1);

  println!("{}", run_part2);

  run_part2
}

pub fn run_part2() -> usize {
  let result: usize = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    .iter()
    .map(|(right, down)| count_trees(*right, *down))
    .product();

  println!("{}", result);

  result
}

fn count_trees(right: usize, down: usize) -> usize {
  let mut curr = 0;
  
  let cols = iter::repeat_with(|| {
    let tmp = curr;
    curr += right;
    tmp
  });

  let result = utils::file::read_lines("../_inputs/day3.txt")
    .step_by(down)
    .zip(cols)
    .filter(|(row, col)| {
      let chars: Vec<char> = row.chars().collect();

      return chars[col % chars.len()] == '#';
    })
    .count();

  return result;
}
