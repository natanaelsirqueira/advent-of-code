#[test]
fn day1() {
    use super::day1;

    assert_eq!(day1::run_part1(), 567_171);
    assert_eq!(day1::run_part2(), 212_428_694);
}

#[test]
fn day2() {
    use super::day2;

    assert_eq!(day2::run_part1(), 622);
    assert_eq!(day2::run_part2(), 263);
}

#[test]
fn day3() {
    use super::day3;

    assert_eq!(day3::run_part1(), 220);
    assert_eq!(day3::run_part2(), 2_138_320_800);
}

#[test]
fn day4() {
    use super::day4;

    assert_eq!(day4::run_part1(), 230);
    assert_eq!(day4::run_part2(), 156);
}

#[test]
fn day5() {
    use super::day5;

    assert_eq!(day5::run_part1(), 801);
    assert_eq!(day5::run_part2(), 597);
}
