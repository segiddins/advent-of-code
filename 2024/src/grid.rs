use std::fmt::{Debug, Display};

pub struct Grid<T> {
    size: (usize, usize),
    grid: Vec<Vec<T>>,
}

#[derive(Clone, Copy, Hash, PartialEq, Eq)]
pub struct Position {
    x: usize,
    y: usize,
}

impl Debug for Position {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

impl Position {
    pub fn distance(&self, other: Position) -> Option<usize> {
        let dx = self.x.abs_diff(other.x);
        let dy = self.y.abs_diff(other.y);
        let squared = dx * dx + dy * dy;
        let root = (squared as f64).sqrt();
        if root.fract() == 0.0 {
            Some(root as usize)
        } else {
            None
        }
    }

    pub fn up(&self) -> Option<Position> {
        if self.y == 0 {
            return None;
        }
        Some(Position {
            x: self.x,
            y: self.y - 1,
        })
    }

    pub fn down(&self) -> Option<Position> {
        Some(Position {
            x: self.x,
            y: self.y + 1,
        })
    }

    pub fn diff(&self, other: &Position) -> (isize, isize) {
        (
            self.x as isize - other.x as isize,
            self.y as isize - other.y as isize,
        )
    }
}

impl<T> Grid<T> {
    pub fn out_of_bounds(&self, pos: Position) -> bool {
        pos.x >= self.size.0 || pos.y >= self.size.1
    }

    pub fn new(grid: Vec<Vec<T>>) -> Self {
        if grid.is_empty() {
            return Self {
                size: (0, 0),
                grid: vec![],
            };
        }
        let size = (grid[0].len(), grid.len());
        Self { size, grid }
    }

    pub fn get(&self, pos: Position) -> Option<&T> {
        if self.out_of_bounds(pos) {
            return None;
        }
        Some(&self.grid[pos.y][pos.x])
    }

    pub fn set(&mut self, pos: Position, value: T) {
        self.grid[pos.y][pos.x] = value;
    }

    pub fn iter(&self) -> GridIterator<T> {
        GridIterator {
            grid: self,
            pos: Position { x: 0, y: 0 },
        }
    }

    pub fn valid_offset(&self, pos: &Position, offset: (isize, isize)) -> Option<Position> {
        let x = pos.x as isize + offset.0;
        let y = pos.y as isize + offset.1;
        if x >= 0 && y >= 0 && x < self.size.0 as isize && y < self.size.1 as isize {
            Some(Position {
                x: x as usize,
                y: y as usize,
            })
        } else {
            None
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
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for row in self.grid.iter() {
            for cell in row.iter() {
                write!(f, "{}", cell)?;
            }
            writeln!(f)?;
        }
        Ok(())
    }
}

pub struct GridIterator<'a, T> {
    grid: &'a Grid<T>,
    pos: Position,
}

impl<'a, T> Iterator for GridIterator<'a, T> {
    type Item = (Position, &'a T);

    fn next(&mut self) -> Option<Self::Item> {
        let pos = self.pos;
        self.pos.x += 1;
        if self.pos.x >= self.grid.size.0 {
            self.pos.x = 0;
            self.pos.y += 1;
        }
        self.grid.get(pos).map(|item| (pos, item))
    }
}

impl<'a, T> IntoIterator for &'a Grid<T> {
    type Item = (Position, &'a T);
    type IntoIter = GridIterator<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        GridIterator {
            grid: self,
            pos: Position { x: 0, y: 0 },
        }
    }
}
