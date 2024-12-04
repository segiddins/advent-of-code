use std::error::Error;

use regex::Regex;

#[derive(Debug)]
pub struct Solution {
    input: String,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        Ok(Self { input })
    }
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i32, Box<dyn Error>> {
        let pattern = Regex::new(r"mul\((\d+),(\d+)\)")?;
        let sum = pattern
            .captures_iter(&self.input)
            .map(|m| m[1].parse::<i32>().unwrap() * m[2].parse::<i32>().unwrap())
            .sum();
        Ok(sum)
    }

    fn part_2(&self) -> Result<i32, Box<dyn Error>> {
        let pattern = Regex::new(r"mul\((\d+),(\d+)\)|(do\(\))|(don't\(\))")?;
        let sum = pattern
            .captures_iter(&self.input)
            .fold((true, 0), |acc, m| {
                if m.get(3).is_some() {
                    (true, acc.1)
                } else if m.get(4).is_some() {
                    (false, acc.1)
                } else if acc.0 {
                    (
                        true,
                        acc.1 + (m[1].parse::<i32>().unwrap() * m[2].parse::<i32>().unwrap()),
                    )
                } else {
                    acc
                }
            })
            .1;
        Ok(sum)
    }
}
