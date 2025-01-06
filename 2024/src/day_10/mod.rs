use std::collections::{HashSet, VecDeque};
use std::fmt::{Debug, Display};
use std::{collections::HashMap, error::Error};

use itertools::Itertools;
use rayon::iter::{repeat, IntoParallelRefIterator, ParallelIterator};

use crate::grid::{Grid, Position};

#[derive(Debug)]
pub struct Solution {
    grid: Grid<isize>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let grid = Grid::new(
            input
                .lines()
                .map(|line| {
                    line.chars()
                        .map(|c| c.to_digit(10).unwrap() as isize)
                        .collect()
                })
                .collect(),
        );

        Ok(Self { grid })
    }
}

fn reachable(grid: &Grid<isize>, a: &Position, b: &Position) -> bool {
    let mut visited = HashSet::new();
    let mut queue = VecDeque::new();
    queue.push_back(*a);
    while let Some(pos) = queue.pop_front() {
        if pos == *b {
            return true;
        }
        for offset in [(0, 1), (1, 0), (0, -1), (-1, 0)] {
            if let Some(new_pos) = grid.valid_offset(&pos, offset) {
                if *grid.get(new_pos).unwrap() != grid.get(pos).unwrap() + 1 {
                    continue;
                }
                if !visited.contains(&new_pos) {
                    visited.insert(new_pos);
                    queue.push_back(new_pos);
                }
            }
        }
    }
    false
}

fn all_paths(grid: &Grid<isize>, a: &Position, b: &Position) -> Vec<Vec<Position>> {
    let mut paths = Vec::new();
    let mut queue = VecDeque::new();
    queue.push_back(vec![*a]);
    while let Some(path) = queue.pop_front() {
        if path.last().is_some_and(|pos| pos == b) {
            paths.push(path.clone());
        }
        for offset in [(0, 1), (1, 0), (0, -1), (-1, 0)] {
            if let Some(new_pos) = grid.valid_offset(path.last().unwrap(), offset) {
                if *grid.get(new_pos).unwrap() != grid.get(*path.last().unwrap()).unwrap() + 1 {
                    continue;
                }
                let mut new_path = path.clone();
                new_path.push(new_pos);
                queue.push_back(new_path);
            }
        }
    }
    paths
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let mut grid = self.grid.clone();
        let zeros = grid
            .iter()
            .filter(|(_, &v)| v == 0)
            .map(|(pos, _)| pos)
            .collect_vec();
        let nines = grid
            .iter()
            .filter(|(_, &v)| v == 9)
            .map(|(pos, _)| pos)
            .collect_vec();

        let count = zeros
            .par_iter()
            .map(|zero| {
                nines
                    .iter()
                    .filter(|nine| reachable(&grid, zero, nine))
                    .count() as i64
            })
            .sum::<i64>();

        Ok(count)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let mut grid = self.grid.clone();
        let zeros = grid
            .iter()
            .filter(|(_, &v)| v == 0)
            .map(|(pos, _)| pos)
            .collect_vec();
        let nines = grid
            .iter()
            .filter(|(_, &v)| v == 9)
            .map(|(pos, _)| pos)
            .collect_vec();

        let count = zeros
            .par_iter()
            .map(|zero| {
                nines
                    .iter()
                    .map(|nine| all_paths(&grid, zero, nine).len() as i64)
                    .sum::<i64>()
            })
            .sum::<i64>();

        Ok(count)
    }
}
