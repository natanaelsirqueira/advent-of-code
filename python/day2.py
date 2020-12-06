from utils import file_readlines

passwords = file_readlines('../_inputs/day2.txt')


def run_part1():
    print(sum([1 for policy_and_password in passwords if validate_part1(policy_and_password)]))


def run_part2():
    print(sum([1 for policy_and_password in passwords if validate_part2(policy_and_password)]))


def validate_part1(policy_and_password):
    policy, password = policy_and_password.split(':')
    count_range, letter = policy.split(' ')
    min_count, max_count = count_range.split('-')

    min_count = int(min_count)
    max_count = int(max_count)

    count = sum([1 for char in password if char == letter])

    return count >= min_count and count <= max_count


def validate_part2(policy_and_password):
    policy, password = policy_and_password.split(':')
    count_range, letter = policy.split(' ')
    position1, position2 = count_range.split('-')

    position1 = int(position1)
    position2 = int(position2)

    char1 = password[position1]
    char2 = password[position2]

    return sum([1 for char in [char1, char2] if char == letter]) == 1
