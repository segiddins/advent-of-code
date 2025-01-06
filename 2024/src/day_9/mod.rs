use std::collections::HashSet;
use std::fmt::{Debug, Display};
use std::{collections::HashMap, error::Error};

use itertools::Itertools;
use rayon::iter::repeat;

#[derive(Debug, Clone, Eq, PartialEq)]
enum BlockType {
    File,
    FreeSpace,
}

#[derive(Clone, Eq, PartialEq, Copy)]
enum Block {
    File(usize),
    FreeSpace,
}

impl Debug for Block {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Block::File(id) => write!(f, "{}", id),
            Block::FreeSpace => write!(f, "."),
        }
    }
}

#[derive(Debug)]
pub struct Solution {
    disk_map: Vec<(isize, BlockType)>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let disk_map = input
            .chars()
            .map(|c| c.to_digit(10).unwrap() as isize)
            .zip(
                vec![BlockType::File, BlockType::FreeSpace]
                    .into_iter()
                    .cycle(),
            )
            .collect_vec();

        Ok(Self { disk_map })
    }
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let mut disk = Vec::<Block>::new();
        for (i, (size, block)) in self.disk_map.iter().enumerate() {
            match block {
                BlockType::File => {
                    assert_eq!(i % 2, 0);
                    for _ in 0..*size {
                        disk.push(Block::File(i / 2));
                    }
                }
                BlockType::FreeSpace => {
                    assert_eq!(i % 2, 1);
                    for _ in 0..*size {
                        disk.push(Block::FreeSpace);
                    }
                }
            }
        }
        if !disk.is_empty() {
            let mut i = 0_usize;
            let mut j = disk.len() - 1;
            while i < j {
                if disk[j] == Block::FreeSpace {
                    j -= 1;
                    continue;
                }

                match disk[i] {
                    Block::File(_) => {
                        i += 1;
                    }
                    Block::FreeSpace => {
                        disk.swap(i, j);
                        j -= 1;
                    }
                }
            }
        };
        let checksum = disk
            .iter()
            .enumerate()
            .map(|(i, b)| match b {
                Block::File(id) => i * id,
                Block::FreeSpace => 0,
            })
            .sum::<usize>();
        Ok(checksum as i64)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let mut disk = Vec::<(usize, Block)>::new();
        for (i, (size, block)) in self.disk_map.iter().enumerate() {
            match block {
                BlockType::File => {
                    assert_eq!(i % 2, 0);
                    disk.push((*size as usize, Block::File(i / 2)));
                }
                BlockType::FreeSpace => {
                    assert_eq!(i % 2, 1);
                    disk.push((*size as usize, Block::FreeSpace));
                }
            }
        }
        if !disk.is_empty() {
            let mut i: usize = 0;
            let mut j = disk.len() - 1;
            while j > 0 {
                if i >= j {
                    i = 0;
                    j -= 1;
                    continue;
                }
                if disk[j].1 == Block::FreeSpace {
                    j -= 1;
                    i = 0;
                    continue;
                }

                match disk[i] {
                    (_, Block::File(_)) => {
                        i += 1;
                    }
                    (len, Block::FreeSpace) if len >= disk[j].0 => {
                        let diff = len - disk[j].0;
                        disk.swap(i, j);
                        if diff > 0 {
                            disk[j].0 -= diff;
                            disk.insert(i + 1, (diff, Block::FreeSpace));
                        } else {
                            // disk.remove(j);
                            j -= 1;
                        }
                        i = 0;
                    }
                    _ => {
                        i += 1;
                    }
                }
            }
        };
        let checksum = disk
            .iter()
            .flat_map(|(len, b)| vec![b; *len])
            .enumerate()
            .map(|(i, b)| match b {
                Block::File(id) => i * id,
                Block::FreeSpace => 0,
            })
            .sum::<usize>();
        Ok(checksum as i64)
    }
}
