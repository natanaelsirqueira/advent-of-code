from itertools import combinations

input_file = open('../_inputs/day1.txt', 'r')

numbers = [int(line.strip()) for line in input_file.readlines()]

input_file.close()


def run_part1():
    for n1, n2 in combinations(numbers, 2):
        if n1 + n2 == 2020:
            print(n1 * n2)
            break


def run_part2():
    for n1, n2, n3 in combinations(numbers, 3):
        if n1 + n2 + n3 == 2020:
            print(n1 * n2 * n3)
            break
