use regex::Regex;

use super::utils;

pub fn run_part1() {
  let regex = Regex::new(r"(\d+)-(\d+) (\w): (\w+)").unwrap();
  // let regex = Regex::new(r"(?P<min>\d+)-(?P<max>\d+) (?P<letter>\w): (?P<password>.+)").unwrap();

  let result = utils::file::read_lines("../_inputs/day2.txt")
    .filter(|line| {
      let captures = regex.captures(line).unwrap();

      // let min = captures.name("min").unwrap().as_str().parse::<usize>().unwrap();
      // let max = captures.name("max").unwrap().as_str().parse::<usize>().unwrap();
      // let letter = captures.name("letter").unwrap().as_str().parse::<char>().unwrap();
      // let password = captures.name("password").unwrap().as_str();

      let min: usize = captures[1].parse().unwrap();
      let max: usize = captures[2].parse().unwrap();
      let letter: char = captures[3].parse().unwrap();
      let password: String = captures[4].to_string();

      let count = password.chars().filter(|character| *character == letter).count();

      return count >= min && count <= max;
    })
    .count();

  println!("{}", result);
}

pub fn run_part2() {
  let regex = Regex::new(r"(\d+)-(\d+) (\w): (\w+)").unwrap();

  let result = utils::file::read_lines("../_inputs/day2.txt")
    .filter(|line| {
      let captures = regex.captures(line).unwrap();

      let position1: usize = captures[1].parse().unwrap();
      let position2: usize = captures[2].parse().unwrap();
      let letter: char = captures[3].parse().unwrap();
      let password: String = captures[4].to_string();

      let characters: Vec<char> = password.chars().collect();

      let char1 = characters[position1 - 1];
      let char2 = characters[position2 - 1];

      return (char1 == letter && char2 != letter) || (char2 == letter && char1 != letter);
      // return [char1, char2].iter().filter(|character| **character == letter).count() == 1;
    })
    .count();

  println!("{}", result);
}
