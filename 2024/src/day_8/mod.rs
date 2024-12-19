use std::collections::HashSet;
use std::fmt::{Debug, Display};
use std::{collections::HashMap, error::Error};

use itertools::Itertools;

use crate::grid::{Grid, Position};

#[derive(Debug)]
pub struct Solution {
    grid: Grid<char>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let grid = Grid::new(input.lines().map(|line| line.chars().collect()).collect());

        Ok(Self { grid })
    }
}

fn antinodes<'a>(grid: &Grid<char>, a: &'a Position, b: &'a Position) -> Vec<Position> {
    let mut antinodes = Vec::new();
    let (dx, dy) = a.diff(b);

    if let Some(pos) = grid.valid_offset(a, (dx, dy)) {
        antinodes.push(pos);
    }
    if let Some(pos) = grid.valid_offset(b, (-dx, -dy)) {
        antinodes.push(pos);
    }

    antinodes
}
fn antinodes2(grid: &Grid<char>, a: &Position, b: &Position) -> Vec<Position> {
    let mut antinodes = Vec::new();
    let (dx, dy) = a.diff(b);

    for mult in -1000..1000 {
        let x = (dx * mult);
        let y = (dy * mult);
        if let Some(pos) = grid.valid_offset(a, (x, y)) {
            antinodes.push(pos);
        } else {
            // break;
        }
    }

    antinodes
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let mut groups = HashMap::new();
        for (pos, &c) in self.grid.iter() {
            if c == '.' {
                continue;
            }
            groups.entry(c).or_insert_with(Vec::new).push(pos);
        }
        let mut an = HashSet::new();
        for (_, group) in groups.iter() {
            for (a, b) in group.iter().tuple_combinations() {
                an.extend(antinodes(&self.grid, a, b));
            }
        }
        Ok(an.len() as i64)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let mut groups = HashMap::new();
        for (pos, &c) in self.grid.iter() {
            if c == '.' {
                continue;
            }
            groups.entry(c).or_insert_with(Vec::new).push(pos);
        }
        let mut an = HashSet::new();
        for (_, group) in groups.iter() {
            for (a, b) in group.iter().tuple_combinations() {
                an.extend(antinodes2(&self.grid, a, b));
            }
        }
        Ok(an.len() as i64)
    }
}
