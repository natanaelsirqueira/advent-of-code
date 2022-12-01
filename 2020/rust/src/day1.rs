use itertools::Itertools;

use super::utils;

pub fn run_part1() -> usize {
  let combination = utils::file::read_lines("../_inputs/day1.txt")
    .map(|line| line.parse::<usize>().unwrap())
    .combinations(2)
    .find(|combination| combination.iter().sum::<usize>() == 2020)
    .unwrap();

  let result = combination[0] * combination[1];
  
  println!("{}", result);

  result
}

pub fn run_part2() -> usize {
  let combination = utils::file::read_lines("../_inputs/day1.txt")
    .map(|line| line.parse::<usize>().unwrap())
    .combinations(3)
    .find(|combination| combination.iter().sum::<usize>() == 2020)
    .unwrap();
  
  let result = combination[0] * combination[1] * combination[2];

  println!("{}", result);

  result
}
