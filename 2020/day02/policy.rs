use std::collections::LinkedList;

#[derive(Debug)]
struct Policy {
    min: usize,
    max: usize,
    c: char
}

fn validate1(password: &str, policy: &Policy) -> bool {
    let size = password.len();
    let new_size = password.replace(policy.c, "").len();
    let diff = size - new_size;
    policy.min <= diff && diff <= policy.max
}

fn validate2(password: &str, policy: &Policy) -> bool {
    let p1 = password.chars().nth(policy.min - 1).unwrap() == policy.c;
    let p2 = password.chars().nth(policy.max - 1).unwrap() == policy.c;
    p1 ^ p2
}

fn main() {
    let content = std::fs::read_to_string("input.txt").expect("could not read file");
    let lines = content.lines();

    let mut objects: LinkedList<(&str, Policy)> = LinkedList::new();

    for line in lines {
        let split: Vec<&str>= line.split(": ").collect();
        let policy_str = split[0];
        let passwd = split[1];

        let po_split: Vec<&str> = policy_str.split(" ").collect();
        let range_str = po_split[0];
        let chr = po_split[1];

        let range_split: Vec<&str> = range_str.split("-").collect();
        let min = range_split[0].parse::<usize>().unwrap();
        let max = range_split[1].parse::<usize>().unwrap();
        let policy = Policy { min: min, max: max, c: chr.chars().next().unwrap() };
        objects.push_back((passwd, policy));
    }

    let mut total = 0;
    let mut total2 = 0;
    for (pass, policy) in objects {
        if validate1(pass, &policy) {
            total += 1;
        }
        if validate2(pass, &policy) {
            total2 += 1;
        }
    }

    println!("P1 result is: {}", total);
    println!("P2 result is: {}", total2);

}
