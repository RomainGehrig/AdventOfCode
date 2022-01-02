use std::str::FromStr;

#[derive(Debug, PartialEq)]
enum Direction {
    Up,
    Down,
    Forward
}

#[derive(Debug)]
struct Action {
    units: usize,
    direction: Direction,
}


impl FromStr for Direction {

    type Err = ();

    fn from_str(input: &str) -> Result<Direction, Self::Err> {
        match input {
            "up"      => Ok(Direction::Up),
            "down"    => Ok(Direction::Down),
            "forward" => Ok(Direction::Forward),
            _         => Err(()),
        }
    }
}



fn main() {
    let content = std::fs::read_to_string("input.txt").expect("could not read file");
    let lines = content.lines();

    let mut actions: Vec<Action> = Vec::new();

    for line in lines {
        let split: Vec<&str>= line.split(" ").collect();
        let dir: Direction = Direction::from_str(split[0]).unwrap();
        let units: usize = split[1].parse::<usize>().unwrap();
        actions.push(Action { units: units, direction: dir });
    }

    {
        let mut depth: usize = 0;
        let mut horizontal: usize = 0;

        for action in actions.iter() {
            let unit = action.units;
            match action.direction {
                Direction::Up      => depth -= unit,
                Direction::Down    => depth += unit,
                Direction::Forward => horizontal += unit,
            }
        }

        println!("P1 result is: {}", depth * horizontal);
    }

    {
        let mut depth: usize = 0;
        let mut horizontal: usize = 0;
        let mut aim: usize = 0;

        for action in actions.iter() {
            let unit = action.units;
            match action.direction {
                Direction::Up      => aim -= unit,
                Direction::Down    => aim += unit,
                Direction::Forward => {
                    horizontal += unit;
                    depth += unit * aim;
                }
            }
        }

        println!("P2 result is: {}", depth * horizontal);
    }

}
