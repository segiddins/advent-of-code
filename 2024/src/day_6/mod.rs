use std::collections::HashSet;
use std::fmt::{Debug, Display};
use std::{error::Error, fmt};

use rayon::iter::{IntoParallelIterator, ParallelIterator};

struct Grid<T> {
    size: (usize, usize),
    grid: Vec<Vec<T>>,
}

impl<T> Grid<T> {
    fn new(grid: Vec<Vec<T>>) -> Self {
        let size = (grid[0].len(), grid.len());
        Self { size, grid }
    }

    fn get(&self, pos: (i32, i32)) -> Option<&T> {
        if pos.0 >= self.size.0 as i32 || pos.1 >= self.size.1 as i32 || pos.0 < 0 || pos.1 < 0 {
            return None;
        }
        Some(&self.grid[pos.1 as usize][pos.0 as usize])
    }

    fn set(&mut self, pos: (i32, i32), value: T) {
        self.grid[pos.1 as usize][pos.0 as usize] = value;
    }

    fn iter(&self) -> GridIterator<T> {
        GridIterator {
            grid: self,
            pos: (0, 0),
        }
    }
}

impl<T: Clone> Clone for Grid<T> {
    fn clone(&self) -> Self {
        Self {
            size: self.size,
            grid: self.grid.clone(),
        }
    }
}

impl<T: Display> Debug for Grid<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for row in self.grid.iter() {
            for cell in row.iter() {
                write!(f, "{}", cell)?;
            }
            writeln!(f)?;
        }
        Ok(())
    }
}

struct GridIterator<'a, T> {
    grid: &'a Grid<T>,
    pos: (i32, i32),
}

impl<'a, T> Iterator for GridIterator<'a, T> {
    type Item = ((i32, i32), &'a T);

    fn next(&mut self) -> Option<Self::Item> {
        let pos = self.pos;
        self.pos.0 += 1;
        if self.pos.0 >= self.grid.size.0 as i32 {
            self.pos.0 = 0;
            self.pos.1 += 1;
        }
        self.grid.get(pos).map(|item| (pos, item))
    }
}

impl<'a, T> IntoIterator for &'a Grid<T> {
    type Item = ((i32, i32), &'a T);
    type IntoIter = GridIterator<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        GridIterator {
            grid: self,
            pos: (0, 0),
        }
    }
}

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

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let mut grid = self.grid.clone();
        let mut pos = grid
            .iter()
            .find(|(_, &c)| c == '^' || c == '>' || c == '<' || c == 'v')
            .expect("No starting position found")
            .0;
        let mut visited = HashSet::new();
        visited.insert(pos);
        loop {
            // println!("{:?}\n{:?}", grid, pos);
            let direction = match grid.get(pos) {
                Some('^') => (0, -1),
                Some('>') => (1, 0),
                Some('<') => (-1, 0),
                Some('v') => (0, 1),
                None => break,
                Some(c) => return Err(format!("Invalid character at {:?}: {:?}", pos, c).into()),
            };
            let next_pos = (pos.0 + direction.0, pos.1 + direction.1);
            match grid.get(next_pos) {
                Some('.') => {
                    let guard = grid.get(pos).unwrap().clone();
                    grid.set(pos, '.');
                    pos = next_pos;
                    grid.set(next_pos, guard);
                }
                Some('#') => {
                    let new_dir = match grid.get(pos) {
                        Some('^') => '>',
                        Some('>') => 'v',
                        Some('<') => '^',
                        Some('v') => '<',
                        Some(c) => return Err(format!("Invalid character: {:?}", c).into()),
                        None => unreachable!(),
                    };
                    grid.set(pos, new_dir);
                    continue;
                }
                _ => break,
            }
            visited.insert(pos);
        }
        Ok(visited.len() as i64)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let mut grid = self.grid.clone();
        let mut pos = grid
            .iter()
            .find(|(_, &c)| c == '^' || c == '>' || c == '<' || c == 'v')
            .expect("No starting position found")
            .0;
        let initial_pos = pos;
        let mut visited = HashSet::new();
        visited.insert(pos);
        loop {
            // println!("{:?}\n{:?}", grid, pos);
            let direction = match grid.get(pos) {
                Some('^') => (0, -1),
                Some('>') => (1, 0),
                Some('<') => (-1, 0),
                Some('v') => (0, 1),
                None => break,
                Some(c) => return Err(format!("Invalid character at {:?}: {:?}", pos, c).into()),
            };
            let next_pos = (pos.0 + direction.0, pos.1 + direction.1);
            match grid.get(next_pos) {
                Some('.') => {
                    let guard = grid.get(pos).unwrap().clone();
                    grid.set(pos, '.');
                    pos = next_pos;
                    grid.set(next_pos, guard);
                }
                Some('#') => {
                    let new_dir = match grid.get(pos) {
                        Some('^') => '>',
                        Some('>') => 'v',
                        Some('<') => '^',
                        Some('v') => '<',
                        Some(c) => return Err(format!("Invalid character: {:?}", c).into()),
                        None => unreachable!(),
                    };
                    grid.set(pos, new_dir);
                    continue;
                }
                _ => break,
            }
            visited.insert(pos);
        }
        visited.remove(&initial_pos);
        Ok(visited
            .into_par_iter()
            .filter(|blocker: &(i32, i32)| {
                let mut pos = initial_pos;
                let mut grid = self.grid.clone();
                grid.set(blocker.clone(), '#');
                let mut visited = HashSet::new();
                loop {
                    let direction = match grid.get(pos) {
                        Some('^') => (0, -1),
                        Some('>') => (1, 0),
                        Some('<') => (-1, 0),
                        Some('v') => (0, 1),
                        None => break,
                        Some(c) => unreachable!("Invalid character: {:?}", c),
                    };
                    if !visited.insert((pos, direction)) {
                        return true;
                    }
                    let next_pos = (pos.0 + direction.0, pos.1 + direction.1);
                    match grid.get(next_pos) {
                        Some('.') => {
                            let guard = grid.get(pos).unwrap().clone();
                            grid.set(pos, '.');
                            pos = next_pos;
                            grid.set(next_pos, guard);
                        }
                        Some('#') => {
                            let new_dir = match grid.get(pos) {
                                Some('^') => '>',
                                Some('>') => 'v',
                                Some('<') => '^',
                                Some('v') => '<',
                                Some(c) => unreachable!("Invalid character: {:?}", c),
                                None => unreachable!(),
                            };
                            grid.set(pos, new_dir);
                            continue;
                        }
                        _ => break,
                    }
                }
                false
            })
            .count() as i64)
    }
}
