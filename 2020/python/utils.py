def file_read_lines(path):
  input_file = open(path, 'r')

  lines = [line.strip() for line in input_file.readlines()]

  input_file.close()

  return lines


def file_read_groups_of_lines(path):
  input_file = open(path, 'r')

  groups = [group for group in input_file.read().split('\n\n')]

  input_file.close()

  return groups
