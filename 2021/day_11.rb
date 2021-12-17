#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  grid = {}
  max_y = $lines.length
  max_x = $lines[0].length
  $lines.each_with_index do |l, y|
    l.chars.each_with_index do |i, x|
      grid[Point.new(x+1, y+1)] = i.to_i
    end
  end

  100.times.sum do
    ng = grid.dup

    flashes = Set.new
    v = ->(pt) do
      ng[pt] += 1
      if ng[pt] > 9 && flashes.add?(pt)
        pt.neighbors(1, min_x: 1, min_y: 1, max_x: max_x, max_y: max_y).each do |n|
          v[n]
        end
      end
    end
    grid.each_key(&v)
    grid = ng.transform_values { |v| v > 9 ? 0 : v}
    flashes.count
  end
end

def part2
  grid = {}
  max_y = $lines.length
  max_x = $lines[0].length
  $lines.each_with_index do |l, y|
    l.chars.each_with_index do |i, x|
      grid[Point.new(x+1, y+1)] = i.to_i
    end
  end

  (0..1_000_000_000).find do
    ng = grid.dup

    flashes = Set.new
    v = ->(pt) do
      ng[pt] += 1
      if ng[pt] > 9 && flashes.add?(pt)
        pt.neighbors(1, min_x: 1, min_y: 1, max_x: max_x, max_y: max_y).each do |n|
          v[n]
        end
      end
    end
    grid.each_key(&v)
    grid = ng.transform_values { |v| v > 9 ? 0 : v}
    flashes.size == grid.size
  end.succ
end

pp part1
pp part2

__END__
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526