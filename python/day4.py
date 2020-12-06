from utils import file_readlines
import re

input_file = open('../_inputs/day4.txt', 'r')
lines = [line.strip().replace("\n", " ") for line in input_file.read().split('\n\n')]

REQUIRED_FIELDS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
BIRTH_YEAR_ALLOWED_RANGE = range(1920, 2003)
ISSUE_YEAR_ALLOWED_RANGE = range(2010, 2021)
EXPIRATION_YEAR_ALLOWED_RANGE = range(2020, 2031)
HEIGHT_REGEX = "^(?P<value>\d+)(?P<unit>cm|in)$"
HAIR_COLOR_REGEX = "^#([0-9a-f]{6})$"
PASSPORT_ID_REGEX = "^\d{9}$"
EYE_COLORS = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]


def run_part1():
    passports = (line.split(' ') for line in lines)

    passport_fields = lambda passport: (field.split(":")[0] for field in passport)
    passport_has_field = lambda passport, field: field in passport_fields(passport)

    valid = filter(lambda passport: all(passport_has_field(passport, field) for field in REQUIRED_FIELDS), passports)

    print(sum(1 for _ in valid))


def run_part2():
    passports = map(lambda line: parse_passport(line), [line.split(' ') for line in lines])

    valid = filter(lambda passport: is_passport_valid(passport), passports)

    print(sum(1 for _ in valid))


def parse_passport(line):
    fields = (field.split(':') for field in line)

    return {key : value for key, value in fields}


def is_passport_valid(passport):
    return all(is_field_valid(passport, field) for field in REQUIRED_FIELDS)


def is_field_valid(passport, field):
    validations = {
        'byr': lambda value: value.isnumeric() and int(value) in BIRTH_YEAR_ALLOWED_RANGE,
        'iyr': lambda value: value.isnumeric() and int(value) in ISSUE_YEAR_ALLOWED_RANGE,
        'eyr': lambda value: value.isnumeric() and int(value) in EXPIRATION_YEAR_ALLOWED_RANGE,
        'hgt': lambda value: is_valid_height(value),
        'hcl': lambda value: re.match(HAIR_COLOR_REGEX, value),
        'ecl': lambda value: value in EYE_COLORS,
        'pid': lambda value: re.match(PASSPORT_ID_REGEX, value),
        'cid': lambda value: True
    }

    return field in passport and validations[field](passport[field])


def is_valid_height(height):
    captures = re.findall(HEIGHT_REGEX, height)

    validations = {
        'cm': lambda value: int(value) in range(150, 194),
        'in': lambda value: int(value) in range(59, 77)
    }

    if len(captures) == 1:
        value, unit = captures[0]

        return validations[unit](value)

    return False
