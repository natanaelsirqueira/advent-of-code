from itertools import islice, count
from functools import reduce
from utils import file_readlines

lines = file_readlines('../_inputs/day3.txt')


def run_part1():
    print(count_trees(3, 1))


def run_part2():
    slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    
    print(reduce(lambda x, y: x * y, [count_trees(right, down) for right, down in slopes]))


def count_trees(right, down):
    str_to_chars = lambda row: [char for char in row]
    rows = map(str_to_chars, islice(lines, 0, None, down))
    tree_map = zip(rows, count(0, right))

    return sum([1 for row, col in tree_map if row[col % len(row)] == "#"])
