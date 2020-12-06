use itertools::Itertools;

use super::utils;

pub fn run_part1() {
  let combination = utils::file::read_lines("../_inputs/day1.txt")
    .map(|line| line.parse::<u32>().unwrap())
    .combinations(2)
    .find(|combination| combination.iter().sum::<u32>() == 2020)
    .unwrap();

  println!("{}", combination[0] * combination[1])
}

pub fn run_part2() {
  let combination = utils::file::read_lines("../_inputs/day1.txt")
    .map(|line| line.parse::<u32>().unwrap())
    .combinations(3)
    .find(|combination| combination.iter().sum::<u32>() == 2020)
    .unwrap();

  println!("{}", combination[0] * combination[1] * combination[2])
}
