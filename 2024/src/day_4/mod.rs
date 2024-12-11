use std::error::Error;

#[derive(Debug)]
pub struct Solution {
    grid: Vec<Vec<char>>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let grid = input.lines().map(|line| line.chars().collect()).collect();
        Ok(Self { grid })
    }
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        fn count_xmas(grid: Vec<Vec<char>>, include_cardinal: bool) -> i64 {
            let mut count = 0;
            for i in 0..grid.len() {
                for j in 0..grid[i].len() {
                    if include_cardinal {
                        if grid.get(i).and_then(|row| row.get(j)) == Some(&'X')
                            && grid.get(i).and_then(|row| row.get(j + 1)) == Some(&'M')
                            && grid.get(i).and_then(|row| row.get(j + 2)) == Some(&'A')
                            && grid.get(i).and_then(|row| row.get(j + 3)) == Some(&'S')
                        {
                            count += 1;
                        }

                        if grid.get(i).and_then(|row| row.get(j)) == Some(&'X')
                            && grid.get(i + 1).and_then(|row| row.get(j)) == Some(&'M')
                            && grid.get(i + 2).and_then(|row| row.get(j)) == Some(&'A')
                            && grid.get(i + 3).and_then(|row| row.get(j)) == Some(&'S')
                        {
                            count += 1;
                        }
                    }

                    if grid.get(i).and_then(|row| row.get(j)) == Some(&'X')
                        && grid.get(i + 1).and_then(|row| row.get(j + 1)) == Some(&'M')
                        && grid.get(i + 2).and_then(|row| row.get(j + 2)) == Some(&'A')
                        && grid.get(i + 3).and_then(|row| row.get(j + 3)) == Some(&'S')
                    {
                        count += 1;
                    }
                }
            }
            count
        }
        let count = count_xmas(self.grid.clone(), true)
            + count_xmas(
                self.grid
                    .iter()
                    .rev()
                    .map(|row| row.clone().into_iter().rev().collect())
                    .collect::<Vec<_>>(),
                true,
            )
            + count_xmas(
                self.grid
                    .iter()
                    .rev()
                    .map(|row| row.clone())
                    .collect::<Vec<_>>(),
                false,
            )
            + count_xmas(
                self.grid
                    .iter()
                    .map(|row| row.clone().into_iter().rev().collect())
                    .collect::<Vec<_>>(),
                false,
            );
        Ok(count)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        fn count_xmas(grid: Vec<Vec<char>>) -> i64 {
            let mut count = 0;
            for i in 1..grid.len() - 1 {
                for j in 1..grid[i].len() - 1 {
                    if grid[i][j] != 'A' {
                        continue;
                    }
                    let tl = grid[i - 1][j - 1];
                    let tr = grid[i - 1][j + 1];
                    let bl = grid[i + 1][j - 1];
                    let br = grid[i + 1][j + 1];

                    let mut p1 = [tl, br];
                    let mut p2 = [tr, bl];
                    p1.sort();
                    p2.sort();

                    if p1 == ['M', 'S'] && p2 == ['M', 'S'] {
                        count += 1;
                    }
                }
            }
            count
        }
        let count = count_xmas(self.grid.clone());
        Ok(count)
    }
}
