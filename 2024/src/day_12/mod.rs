use std::borrow::Borrow;
use std::cell::RefCell;
use std::collections::{HashSet, VecDeque};
use std::default;
use std::fmt::{Debug, Display};
use std::hash::Hash;
use std::rc::Rc;
use std::{collections::HashMap, error::Error};

use itertools::Itertools;
use rayon::collections::hash_set;
use rayon::iter::repeat;

use crate::grid::{Grid, Position, CARGINAL_OFFSETS};

struct BiMap<T> {
    forward: HashMap<T, Rc<HashSet<T>>>,
}

impl<T: Hash + Eq + Copy> BiMap<T> {
    fn merge(&mut self, a: T, b: T) {
        if a == b {
            self.forward.entry(a).or_insert_with(|| {
                let mut hs = HashSet::new();
                hs.insert(a);
                Rc::from(hs)
            });
            return;
        }

        let ga = self.forward.remove(&a);
        let gb = self.forward.remove(&b);

        if let Some(ref rca) = ga {
            if let Some(ref rcb) = gb {
                if Rc::as_ptr(rca) == Rc::as_ptr(rcb) {
                    self.forward.insert(a, rca.clone());
                    self.forward.insert(b, rcb.clone());
                    return;
                }
            }
        }

        let mut combined: HashSet<T> = ga
            .unwrap_or_default()
            .union(gb.unwrap_or_default().borrow())
            .cloned()
            .collect();
        combined.insert(a);
        combined.insert(b);

        let rc = Rc::from(combined);
        for pos in rc.iter() {
            self.forward.insert(*pos, Rc::clone(&rc));
        }
    }
}

impl<T> Default for BiMap<T> {
    fn default() -> Self {
        Self {
            forward: Default::default(),
        }
    }
}

#[derive(Debug)]
pub struct Solution {
    grid: Grid<char>,
    groups: Vec<HashSet<Position>>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let grid = Grid::from_str(&input);

        let groups = {
            let mut groups = BiMap::<Position>::default();

            for (pos, c) in grid.iter() {
                groups.merge(pos, pos);
                for offset in CARGINAL_OFFSETS {
                    let Some(new_pos) = grid.valid_offset(&pos, offset) else {
                        continue;
                    };
                    if grid.get(new_pos).unwrap() != c {
                        continue;
                    }

                    groups.merge(pos, new_pos);
                }
            }

            groups.forward
        };

        let groups = groups
            .into_values()
            .unique_by(|g| Rc::<HashSet<_>>::as_ptr(&g))
            .map(|g| Rc::unwrap_or_clone(g))
            .collect_vec();

        Ok(Self { grid, groups })
    }
}

fn cost(grid: &Grid<char>, group: &HashSet<Position>) -> i64 {
    let perimeter = group
        .iter()
        .map(|p| {
            CARGINAL_OFFSETS
                .iter()
                .map(|offset| {
                    if let Some(pos) = grid.valid_offset(p, *offset) {
                        if group.contains(&pos) {
                            0
                        } else {
                            1
                        }
                    } else {
                        1
                    }
                })
                .sum::<i64>()
        })
        .sum::<i64>();
    perimeter * group.len() as i64
}

fn cost2(grid: &Grid<char>, group: &HashSet<Position>) -> i64 {
    let mut visited: HashSet<(Position, (isize, isize))> = HashSet::new();
    let mut perimeter = 0;

    for pos in group.iter().sorted() {
        for o in CARGINAL_OFFSETS {
            if let Some(np) = grid.valid_offset(pos, o) {
                if group.contains(&np) {
                    continue;
                }
            }

            if visited.insert((*pos, o)) {
                perimeter += 1;
            }

            match o {
                (0, _) => {
                    if let Some(left) = grid.valid_offset(pos, (-1, 0)) {
                        visited.insert((left, o));
                    }
                    if let Some(right) = grid.valid_offset(pos, (1, 0)) {
                        visited.insert((right, o));
                    }
                }
                (_, 0) => {
                    if let Some(up) = grid.valid_offset(pos, (0, -1)) {
                        visited.insert((up, o));
                    }
                    if let Some(down) = grid.valid_offset(pos, (0, 1)) {
                        visited.insert((down, o));
                    }
                }
                _ => unreachable!(),
            }
        }
    }

    perimeter * group.len() as i64
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        // 1467622 too low
        // 1473018 too low
        // 1494342
        Ok(self.groups.iter().map(|g| cost(&self.grid, &g)).sum())
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        Ok(self.groups.iter().map(|g| cost2(&self.grid, &g)).sum())
    }
}
