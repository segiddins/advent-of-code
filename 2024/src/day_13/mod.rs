use std::borrow::Borrow;
use std::cell::RefCell;
use std::cmp::{max, min};
use std::collections::{HashSet, VecDeque};
use std::fmt::{Debug, Display};
use std::hash::Hash;
use std::ops::Div;
use std::rc::Rc;
use std::{collections::HashMap, error::Error};
use std::{default, num};

use ::num::integer::{gcd, lcm};
use ::num::{range_step_inclusive, Integer};
use indicatif::ParallelProgressIterator;
use itertools::Itertools;
use rayon::collections::hash_set;
use rayon::iter::{repeat, IntoParallelRefIterator, ParallelIterator};
use tracing_indicatif::span_ext::IndicatifSpanExt;

use crate::grid::{Grid, Position, CARGINAL_OFFSETS};

#[derive(Debug, Clone)]
struct Pos {
    x: i64,
    y: i64,
}

#[derive(Debug)]
struct Machine {
    a: Pos,
    b: Pos,
    prize: Pos,
}

#[derive(Debug)]
pub struct Solution {
    machines: Vec<Machine>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let pattern = regex::RegexBuilder::new(
            r"Button A: X([+]\d+), Y([+]\d+)\nButton B: X([+]\d+), Y([+]\d+)\nPrize: X=(\d+), Y=(\d+)",
        )
        .multi_line(true)
        .build()?;
        let machines = input
            .split("\n\n")
            .map(|m| {
                let captures = pattern.captures(m).expect(
                    format!("Failed to capture: {:?} with pattern: {:?}", m, pattern).as_str(),
                );
                Machine {
                    a: Pos {
                        x: captures[1].parse().unwrap(),
                        y: captures[2].parse().unwrap(),
                    },
                    b: Pos {
                        x: captures[3].parse().unwrap(),
                        y: captures[4].parse().unwrap(),
                    },
                    prize: Pos {
                        x: captures[5].parse().unwrap(),
                        y: captures[6].parse().unwrap(),
                    },
                }
            })
            .collect();
        Ok(Self { machines })
    }
}

fn ext_euclid(a: i64, b: i64) -> (i64, i64, i64) {
    let mut r0 = a;
    let mut r1 = b;
    let mut s0 = 1;
    let mut s1 = 0;
    let mut t0 = 0;
    let mut t1 = 1;
    while r1 != 0 {
        let q = r0 / r1;
        let r2 = r0 - q * r1;
        let s2 = s0 - q * s1;
        let t2 = t0 - q * t1;
        r0 = r1;
        r1 = r2;
        s0 = s1;
        s1 = s2;
        t0 = t1;
        t1 = t2;
    }
    (s0, t0, r0)
}

fn cost1(machine: &Machine) -> Option<i64> {
    let denomk1 = machine.b.x * machine.a.y - machine.a.x * machine.b.y;
    let k1num = machine.prize.y * machine.b.x - machine.prize.x * machine.b.y;
    let k1 = k1num / denomk1;
    if k1num % denomk1 != 0 {
        return None;
    }
    let k2num = machine.prize.x - machine.a.x * k1;
    if k2num % machine.b.x != 0 {
        return None;
    }
    let k2 = k2num / machine.b.x;
    Some(3 * k1 + k2)
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let res = self.machines.par_iter().filter_map(cost1).sum();
        Ok(res)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let machines = self
            .machines
            .iter()
            .map(|m| Machine {
                a: m.a.clone(),
                b: m.b.clone(),
                prize: Pos {
                    x: m.prize.x + 10_000_000_000_000,
                    y: m.prize.y + 10_000_000_000_000,
                },
            })
            .collect_vec();
        let res = machines.par_iter().progress().filter_map(cost1).sum();
        Ok(res)
    }
}
