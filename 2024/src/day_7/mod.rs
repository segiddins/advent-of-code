use std::fmt::Debug;
use std::{collections::HashMap, error::Error};

use itertools::{repeat_n, Itertools};
use rayon::iter::{IntoParallelRefIterator, ParallelBridge, ParallelIterator};

#[derive(Debug)]
pub struct Solution {
    equations: Vec<(i64, Vec<i64>)>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let equations = input
            .lines()
            .map(|line| {
                let (left, right) = line.split_once(':').unwrap();
                (
                    left.parse().unwrap(),
                    right
                        .split_whitespace()
                        .map(|s| s.parse().unwrap())
                        .collect(),
                )
            })
            .collect();
        Ok(Self { equations })
    }
}

fn concat(a: i64, b: i64) -> Option<i64> {
    a.checked_mul(10_i64.pow(b.ilog10() + 1))?.checked_add(b)
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        Ok(self
            .equations
            .par_iter()
            .filter(|(lhs, rhs)| {
                repeat_n(vec![i64::checked_add, i64::checked_mul], rhs.len() - 1)
                    .multi_cartesian_product()
                    .par_bridge()
                    .any(|mut ops| {
                        let res = rhs
                            .iter().copied()
                            .reduce(|a, b| {
                                let f = ops.pop().unwrap();
                                f(a, b).unwrap()
                            })
                            .unwrap();
                        // println!("{:?} = {:?} -> {:?} => {}", lhs, rhs, ops, res);
                        *lhs == res
                    })
            })
            .map(|(lhs, _)| lhs)
            .sum::<i64>())
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let op_options = vec![i64::checked_add, i64::checked_mul, concat];
        let counts = self
            .equations
            .iter()
            .map(|(_, rhs)| rhs.len())
            .unique()
            .fold(
                HashMap::new(),
                |mut acc: HashMap<usize, Vec<Vec<&fn(i64, i64) -> Option<i64>>>>, len| {
                    acc.entry(len).or_insert(
                        repeat_n(&op_options, len - 1)
                            .multi_cartesian_product()
                            .collect_vec(),
                    );
                    acc
                },
            );
        let answers = self
            .equations
            .par_iter()
            .filter(|(lhs, rhs)| {
                counts.get(&rhs.len()).unwrap().iter().any(|ops| {
                    let res = rhs
                        .iter().copied()
                        .enumerate()
                        .reduce(|(i, a), (j, b)| {
                            let f = ops[i];
                            (j, f(a, b).unwrap())
                        })
                        .unwrap()
                        .1;
                    res == *lhs
                })
            })
            .map(|(lhs, _)| *lhs)
            .sum::<i64>();
        Ok(answers)
    }
}
