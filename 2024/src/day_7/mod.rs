use std::error::Error;
use std::fmt::Debug;

use itertools::{repeat_n, Itertools};
use rayon::iter::{ParallelBridge, ParallelIterator};

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
        let mut equations = self.equations.clone();
        equations.retain(|(lhs, rhs)| {
            repeat_n(vec![i64::checked_add, i64::checked_mul], rhs.len() - 1)
                .into_iter()
                .multi_cartesian_product()
                .par_bridge()
                .any(|mut ops| {
                    let res = rhs
                        .iter()
                        .map(|v| *v)
                        .reduce(|a, b| {
                            let f = ops.pop().unwrap();
                            f(a, b).unwrap()
                        })
                        .unwrap();
                    // println!("{:?} = {:?} -> {:?} => {}", lhs, rhs, ops, res);
                    *lhs == res
                })
        });
        Ok(equations.iter().map(|(lhs, _)| lhs).sum::<i64>())
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let mut equations = self.equations.clone();
        let op_options = vec![i64::checked_add, i64::checked_mul, concat];
        let mut counts = equations.iter().counts_by(|(_, rhs)| rhs.len());
        println!("{:?}", counts);
        equations.retain(|(lhs, rhs)| {
            repeat_n(&op_options, rhs.len() - 1)
                .multi_cartesian_product()
                .par_bridge()
                .any(|mut ops| {
                    let res = rhs
                        .iter()
                        .map(|v| *v)
                        .reduce(|a, b| {
                            let f = ops.pop().unwrap();
                            f(a, b).unwrap()
                        })
                        .unwrap();
                    res == *lhs
                })
        });
        Ok(equations.iter().map(|(lhs, _)| *lhs).sum::<i64>())
    }
}
