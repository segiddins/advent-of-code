use std::{error::Error, fs, path::Path, time::Instant};

use clap::Parser;
use clap_derive::{Parser, ValueEnum};

mod day_1;
mod day_2;
mod day_3;
mod day_4;

#[derive(Debug, Clone, ValueEnum)]
enum Input {
    Example,
    Input,
    Both,
}

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Args {
    /// Run all days
    #[arg(short, long, conflicts_with = "day", action = clap::ArgAction::SetTrue, required_unless_present = "day")]
    all: bool,

    /// Day to run
    #[arg(short, long, conflicts_with = "all", required_unless_present = "all", value_parser = clap::value_parser!(u8).range(1..=25))]
    day: Option<u8>,

    /// Part to run
    #[arg(short, long, default_value = "both")]
    input: Input,
}

trait Solution {
    fn part_1(&self) -> Result<i32, Box<dyn Error>>;
    fn part_2(&self) -> Result<i32, Box<dyn Error>>;
}

impl Args {
    fn run_day(&self, day: u8) -> Result<(), Box<dyn Error>> {
        let file_names: Vec<&str> = match self.input {
            Input::Example => ["example.txt"].to_vec(),
            Input::Input => ["input.txt"].to_vec(),
            Input::Both => ["example.txt", "input.txt"].to_vec(),
        };
        let dir = Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("src")
            .join(format!("day_{}", day));

        for file_name in file_names {
            let input = fs::read_to_string(dir.join(file_name))?;

            let solution: Box<dyn Solution> = match day {
                1 => Box::new(day_1::Day1::new(input)?),
                2 => Box::new(day_2::Solution::new(input)?),
                3 => Box::new(day_3::Solution::new(input)?),
                4 => Box::new(day_4::Solution::new(input)?),
                _ => return Err(format!("Day {} not implemented", day).into()),
            };
            {
                let start = Instant::now();
                let result = solution.part_1()?;
                let elapsed = start.elapsed();
                println!("Part 1: {:#?} in {:?}", result, elapsed);
            }
            {
                let start = Instant::now();
                let result = solution.part_2()?;
                let elapsed = start.elapsed();
                println!("Part 2: {:#?} in {:?}", result, elapsed);
            }
        }

        Ok(())
    }
    fn run(&self) -> Result<(), Box<dyn Error>> {
        if self.all {
            for day in 1..=25 {
                println!("Day {}", day);
                self.run_day(day)?;
                println!();
            }
        } else if let Some(day) = self.day {
            self.run_day(day)?;
        } else {
            return Err("No day specified".into());
        }
        Ok(())
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    let args = Args::parse();
    args.run()
}
