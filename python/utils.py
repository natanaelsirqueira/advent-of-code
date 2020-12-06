def file_readlines(path):
  input_file = open(path, 'r')

  lines = [line.strip() for line in input_file.readlines()]

  input_file.close()

  return lines
