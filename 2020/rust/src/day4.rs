use regex::Regex;
use std::ops::RangeInclusive;

use super::utils;

const REQUIRED_FIELDS: [&str; 7] = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];

const BIRTH_YEAR_ALLOWED_RANGE: RangeInclusive<i16> = 1920..=2002;
const ISSUE_YEAR_ALLOWED_RANGE: RangeInclusive<i16> = 2010..=2020;
const EXPIRATION_YEAR_ALLOWED_RANGE: RangeInclusive<i16> = 2020..=2030;
const HEIGHT_REGEX: &str = r"^(?P<value>\d+)(?P<unit>cm|in)$";
const HAIR_COLOR_REGEX: &str = r"^#([0-9a-f]{6})$";
const PASSPORT_ID_REGEX: &str = r"^\d{9}$";
const EYE_COLORS: [&str; 7] = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];

pub fn run_part1() -> usize {
  let result = utils::file::read_to_string("../_inputs/day4.txt")
    .trim()
    .split("\n\n")
    .map(|line| line.replace("\n", " "))
    .filter(|line| {
      let passport_fields: Vec<&str> = line
        .split(" ")
        .map(|field| field.split(":").collect::<Vec<&str>>()[0])
        .collect();

      REQUIRED_FIELDS
        .iter()
        .all(|required_field| passport_fields.contains(required_field))
    })
    .count();

  println!("{}", result);

  result
}

pub fn run_part2() -> usize {
  let result = utils::file::read_to_string("../_inputs/day4.txt")
    .trim()
    .split("\n\n")
    .map(|line| line.replace("\n", " "))
    .filter(|line| {
      let passport_fields: Vec<Vec<&str>> = line
        .split(" ")
        .map(|field| field.split(":").collect::<Vec<&str>>())
        .collect();

      REQUIRED_FIELDS.iter().all(|required_field| {
        match passport_fields
          .iter()
          .find(|field| &field[0] == required_field)
        {
          None => false,
          Some(field) => is_field_valid(field[0], field[1]),
        }
      })
    })
    .count();

  println!("{}", result);

  result
}

fn is_field_valid(key: &str, val: &str) -> bool {
  match key {
    "byr" => is_integer_in_range(val, BIRTH_YEAR_ALLOWED_RANGE),
    "iyr" => is_integer_in_range(val, ISSUE_YEAR_ALLOWED_RANGE),
    "eyr" => is_integer_in_range(val, EXPIRATION_YEAR_ALLOWED_RANGE),
    "hgt" => is_valid_height(val),
    "hcl" => is_match(val, HAIR_COLOR_REGEX),
    "ecl" => EYE_COLORS.contains(&val),
    "pid" => is_match(val, PASSPORT_ID_REGEX),
    "cid" => true,
    _ => false,
  }
}

fn is_integer_in_range(val: &str, range: RangeInclusive<i16>) -> bool {
  match val.parse::<i16>() {
    Ok(num) => range.contains(&num),
    _ => false,
  }
}

fn is_valid_height(val: &str) -> bool {
  match Regex::new(HEIGHT_REGEX).unwrap().captures(val) {
    None => false,
    Some(captures) => {
      let value = captures.name("value").unwrap().as_str();
      let unit = captures.name("unit").unwrap().as_str();

      match unit {
        "cm" => is_integer_in_range(value, 150..=193),
        "in" => is_integer_in_range(value, 59..=76),
        _ => false,
      }
    }
  }
}

fn is_match(val: &str, regex: &str) -> bool {
  Regex::new(regex).unwrap().is_match(val)
}
