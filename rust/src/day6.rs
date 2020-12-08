use std::collections::HashMap;
use std::iter::Iterator;
use itertools::Itertools;

use super::utils;

pub fn run_part1() {
  let result: usize = utils::file::read_to_string("../_inputs/day6.txt")
    .trim()
    .split("\n\n")
    .map(|group| {
      group
        .split("\n")
        .flat_map(|line| line.chars())
        .unique()
        .count()
    })
    .sum();

  println!("{}", result)
}

pub fn run_part2() {
  let result: usize = utils::file::read_to_string("../_inputs/day6.txt")
    .trim()
    .split("\n\n")
    .map(|group| {
      let group_answers: Vec<&str> = group.split("\n").collect();
      let group_size = group_answers.len();

      let mut answers_frequencies: HashMap<char, usize> = HashMap::new();

      for person_answers in group_answers {
        for answer in person_answers.chars() {
          *answers_frequencies.entry(answer).or_insert(0) += 1;
        }
      }

      answers_frequencies
        .iter()
        .filter(|(_key, value)| **value == group_size)
        .count()
    })
    .sum();

  println!("{}", result)
}
