pub mod file {
  use std::fs;
  use std::io;
  use std::io::BufRead;

  pub fn read_to_string(path: &str) -> String {
    fs::read_to_string(path).unwrap()
  }

  pub fn read_lines(path: &str) -> impl Iterator<Item = String> {
    let file = fs::File::open(path).unwrap();
    let content = io::BufReader::new(file);

    content.lines().map(|line| line.unwrap())
  }
}
