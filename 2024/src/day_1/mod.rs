use std::error::Error;

use itertools::Itertools;

#[derive(Debug)]
pub struct Day1 {
    left: Vec<i64>,
    right: Vec<i64>,
}

impl Day1 {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let (mut left, mut right): (Vec<i64>, Vec<i64>) = input
            .split("\n")
            .map(|line| {
                line.split_whitespace()
                    .map(|s| s.parse::<i64>().unwrap())
                    .collect_tuple::<(i64, i64)>()
                    .ok_or_else(|| format!("line should contain two numbers: {:?}", line).into())
            })
            .collect::<Result<Vec<(i64, i64)>, Box<dyn Error>>>()?
            .into_iter()
            .unzip();

        left.sort();
        right.sort();
        Ok(Self { left, right })
    }
}

impl crate::Solution for Day1 {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let result = self
            .left
            .iter()
            .zip(self.right.iter())
            .map(|(l, r)| (l - r).abs())
            .sum();

        Ok(result)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let counts = self.right.iter().counts();
        Ok(self
            .left
            .iter()
            .map(|l| l * *counts.get(&l).unwrap_or(&0) as i64)
            .sum())
    }
}
