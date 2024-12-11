use std::error::Error;

use itertools::Itertools;
use topological_sort::TopologicalSort;

#[derive(Debug)]
pub struct Solution {
    rules: Vec<(i64, i64)>,
    updates: Vec<Vec<i64>>,
}

impl Solution {
    pub fn new(input: String) -> Result<Self, Box<dyn Error>> {
        let (rules, updates) = input.split_once("\n\n").unwrap();
        let rules = rules
            .lines()
            .map(|line| {
                let (a, b) = line.split_once("|").unwrap();
                (a.parse().unwrap(), b.parse().unwrap())
            })
            .collect();
        let updates = updates
            .lines()
            .map(|line| line.split(",").map(|s| s.parse().unwrap()).collect())
            .collect();
        Ok(Self { rules, updates })
    }

    fn valid_update(&self, update: &[i64]) -> bool {
        for (a, b) in self.rules.iter() {
            if let Some(p1) = update.iter().position(|&x| x == *a) {
                if let Some(p2) = update.iter().position(|&x| x == *b) {
                    if p1 > p2 {
                        return false;
                    }
                }
            }
        }
        true
    }
}

impl crate::Solution for Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>> {
        let middle_sum: i64 = self
            .updates
            .iter()
            .filter(|update| self.valid_update(update))
            .map(|update| update[update.len() / 2])
            .sum();
        Ok(middle_sum)
    }

    fn part_2(&self) -> Result<i64, Box<dyn Error>> {
        let invalid_updates = self
            .updates
            .iter()
            .filter(|update| !self.valid_update(update))
            .collect_vec();

        let topological_sort = |update: &Vec<i64>| {
            let mut topo: TopologicalSort<i64> = TopologicalSort::new();
            self.rules
                .iter()
                .filter(|(a, b)| update.contains(a) && update.contains(b))
                .for_each(|(a, b)| topo.add_dependency(a.clone(), b.clone()));
            topo.collect_vec()
        };

        let middle_sum: i64 = invalid_updates
            .iter()
            .map(|update| topological_sort(update))
            .map(|update: Vec<i64>| update[update.len() / 2])
            .sum();
        Ok(middle_sum)
    }
}
