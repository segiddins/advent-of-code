use std::error::Error;

use itertools::Itertools;

#[derive(Debug)]
pub struct Solution {
    reports: Vec<Vec<i32>>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let reports: Vec<Vec<i32>> = input
            .split("\n")
            .map(|line| {
                line.split_whitespace()
                    .map(|s| s.parse::<i32>().unwrap())
                    .collect_vec()
            })
            .collect();

        Ok(Self { reports })
    }
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i32, Box<dyn Error>> {
        fn valid(report: &Vec<i32>) -> bool {
            report
                .iter()
                .tuple_windows()
                .all(|(a, b)| a < b && (b - a) <= 3)
                || report
                    .iter()
                    .tuple_windows()
                    .all(|(a, b)| a > b && (a - b) <= 3)
        }
        let result = self.reports.iter().filter(|report| valid(report)).count() as i32;

        Ok(result)
    }

    fn part_2(&self) -> Result<i32, Box<dyn Error>> {
        fn valid(report: &Vec<i32>) -> bool {
            report
                .iter()
                .tuple_windows()
                .all(|(a, b)| a < b && (b - a) <= 3)
                || report
                    .iter()
                    .tuple_windows()
                    .all(|(a, b)| a > b && (a - b) <= 3)
        }
        fn perms<'a>(report: &'a Vec<i32>) -> impl Iterator<Item = Vec<i32>> + 'a {
            report
                .iter()
                .combinations(report.len() - 1)
                .map(|v| v.into_iter().copied().collect())
        }
        let result = self
            .reports
            .iter()
            .filter(|report| perms(report).any(|perm| valid(&perm)))
            .count() as i32;

        Ok(result)
    }
}
