#![allow(unused)]

use std::{error::Error, fmt::Debug, fs, path::Path, time::Instant};

use clap::Parser;
use clap_derive::{Parser, ValueEnum};

mod day_1;
mod day_10;
mod day_2;
mod day_3;
mod day_4;
mod day_5;
mod day_6;
mod day_7;
mod day_8;
mod day_9;

mod grid;

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
    fn part_1(&self) -> Result<i64, Box<dyn Error>>;
    fn part_2(&self) -> Result<i64, Box<dyn Error>>;
}

impl Args {
    fn solution_for_day(
        &self,
        day: u8,
        input: String,
    ) -> Result<Box<dyn Solution>, Box<dyn std::error::Error>> {
        match day {
            1 => Ok(Box::new(day_1::Day1::new(input)?)),
            2 => Ok(Box::new(day_2::Solution::new(input)?)),
            3 => Ok(Box::new(day_3::Solution::new(input)?)),
            4 => Ok(Box::new(day_4::Solution::new(input)?)),
            5 => Ok(Box::new(day_5::Solution::new(input)?)),
            6 => Ok(Box::new(day_6::Solution::new(input)?)),
            7 => Ok(Box::new(day_7::Solution::new(input)?)),
            8 => Ok(Box::new(day_8::Solution::new(input)?)),
            9 => Ok(Box::new(day_9::Solution::new(input)?)),
            10 => Ok(Box::new(day_10::Solution::new(input)?)),
            _ => return Err(format!("Day {} not implemented", day).into()),
        }
    }
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

            let solution = self.solution_for_day(day, input)?;
            {
                let start = Instant::now();
                let result = solution.part_1()?;
                let elapsed = start.elapsed();
                println!("Part 1: {:#?} in {:?}", &result, elapsed);
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
