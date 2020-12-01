use std::collections::HashSet;

fn main() {
    let content = std::fs::read_to_string("input.txt").expect("could not read file");
    let lines = content.lines();
    let values = lines.map(|line| line.parse::<i32>().unwrap());

    let mut set = HashSet::<i32>::default();
    for v in values.clone() {
        set.insert(v);
    }

    let mut result: i32 = 0;
    for v in values.clone() {
        let diff = 2020 - v;
        if set.contains(&diff) {
            result = diff * v;
            break;
        }
    }

    println!("P1 Result is: {}", result);

    for v in values.clone() {
        for u in values.clone() {
            let diff = 2020 - v - u;
            if set.contains(&diff) {
                result = v * u * diff;
                break;
            }
        }
    }

    println!("P2 Result is: {}", result);
}
