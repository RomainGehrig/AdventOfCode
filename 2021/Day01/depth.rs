use std::iter::Iterator;

fn main() {
    let content = std::fs::read_to_string("input.txt").expect("could not read file");
    let lines = content.lines();
    let values = lines.map(|line| line.parse::<i32>().unwrap());

    let mut increased: i32 = 0;
    for (v1, v2) in Iterator::zip(values.clone(), values.clone().skip(1)) {
        if v2 > v1 {
            increased += 1;
        }
    }

    println!("P1 Result is: {}", increased);

    let mut increased2: i32 = 0;
    for (v1, v2) in Iterator::zip(values.clone(), values.clone().skip(3)) {
        if v2 > v1 {
            increased2 += 1;
        }
    }

    println!("P2 Result is: {}", increased2);
}
