from utils import file_read_lines
from functools import reduce

lines = file_read_lines('../_inputs/day5.txt')


def run_part1():
  print(max(calculate_seats_id(boarding_pass) for boarding_pass in lines))


def run_part2():
  seats_ids = sorted((calculate_seats_id(boarding_pass) for boarding_pass in lines))

  last_id = seats_ids[0]

  for seat_id in seats_ids:
    if seat_id - last_id > 1:
      print(last_id + 1)
      break

    last_id = seat_id


def calculate_seats_id(boarding_pass):
  row_config = boarding_pass[:7]
  column_config = boarding_pass[7:]

  row = calculate(row_config, "B")
  column = calculate(column_config, "R")

  return row * 8 + column


def calculate(chars, truthy_char):
  return sum(2 ** index for index, char in enumerate(reversed(chars)) if char == truthy_char)
