use std::collections::{HashSet, VecDeque};
use std::fmt::{Debug, Display};
use std::{collections::HashMap, error::Error};

use itertools::Itertools;
use rayon::iter::repeat;

use crate::grid::{Grid, Position};

#[derive(Debug)]
pub struct Solution {
    stones: Vec<i64>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let stones = input
            .split_whitespace()
            .map(|s| s.parse())
            .collect::<Result<Vec<i64>, _>>()?;

        Ok(Self { stones })
    }
}

fn split_even(n: i64) -> Option<(i64, i64)> {
    let mut digits = Vec::with_capacity(10);
    let mut n = n;
    while n > 0 {
        digits.push(n % 10);
        n /= 10;
    }
    if digits.len() % 2 != 0 {
        return None;
    }
    digits.reverse();
    let left = digits
        .iter()
        .take(digits.len() / 2)
        .copied()
        .reduce(|a, b| a * 10 + b)
        .unwrap();
    let right = digits
        .iter()
        .skip(digits.len() / 2)
        .copied()
        .reduce(|a, b| a * 10 + b)
        .unwrap();
    Some((left, right))
}

fn iterate(stones: Vec<i64>, iterations: usize) -> Vec<i64> {
    let mut stones = stones;
    for _ in 0..iterations {
        let mut new_stones = Vec::with_capacity(stones.len() * 2);
        for stone in stones {
            if stone == 0 {
                new_stones.push(1);
            } else if let Some((left, right)) = split_even(stone) {
                new_stones.push(left);
                new_stones.push(right);
            } else {
                new_stones.push(stone * 2024);
            }
        }
        stones = new_stones;
    }
    stones
}

fn evolve(counts: HashMap<i64, i64>) -> HashMap<i64, i64> {
    let mut new_counts = HashMap::<i64, i64>::new();
    for (stone, count) in counts {
        if stone == 0 {
            *new_counts.entry(1).or_default() += count;
        } else if let Some((left, right)) = split_even(stone) {
            *new_counts.entry(left).or_default() += count;
            *new_counts.entry(right).or_default() += count;
        } else {
            *new_counts.entry(stone * 2024).or_default() += count;
        }
    }
    new_counts
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let stones = iterate(self.stones.clone(), 25);
        Ok(stones.len() as i64)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let mut counts: HashMap<i64, i64> = HashMap::<i64, i64>::new();
        for stone in self.stones.iter() {
            *counts.entry(*stone).or_insert(0) += 1;
        }

        for i in 0..75 {
            counts = evolve(counts);
        }

        Ok(counts.values().sum::<i64>())
    }
}
