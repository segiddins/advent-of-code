use std::error::Error;

use itertools::Itertools;

use crate::Solution;

#[derive(Debug)]
pub struct Day1 {
    left: Vec<i32>,
    right: Vec<i32>,
}

impl Day1 {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let (mut left, mut right): (Vec<i32>, Vec<i32>) = input
            .split("\n")
            .map(|line| {
                line.split_whitespace()
                    .map(|s| s.parse::<i32>().unwrap())
                    .collect_tuple::<(i32, i32)>()
                    .ok_or_else(|| format!("line should contain two numbers: {:?}", line).into())
            })
            .collect::<Result<Vec<(i32, i32)>, Box<dyn Error>>>()?
            .into_iter()
            .unzip();

        left.sort();
        right.sort();
        Ok(Self { left, right })
    }
}

impl Solution for Day1 {
    fn part_1(&self) -> Result<i32, Box<dyn Error>> {
        let result = self
            .left
            .iter()
            .zip(self.right.iter())
            .map(|(l, r)| (l - r).abs())
            .sum();

        Ok(result)
    }

    fn part_2(&self) -> Result<i32, Box<dyn Error>> {
        let counts = self.right.iter().counts();
        Ok(self
            .left
            .iter()
            .map(|l| l * *counts.get(&l).unwrap_or(&0) as i32)
            .sum())
    }
}
