#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def fold(grid, along, width, height)
  ax, v = along
  v = v.to_i

  case ax
  when 'x'
    nw, nh = v, height
    # nw - (pt.x - nw) => 2 * nw - pt.x
    nm = grid.map { |pt| pt.x >= nw ? Point.new(2 * nw - pt.x, pt.y) : pt }.to_set
    [nm, nw, nh]
  when 'y'
    nw, nh = width, v
    nm = grid.map { |pt| pt.y >= nh ? Point.new(pt.x, 2 * nh - pt.y) : pt }.to_set
    [nm, nw, nh]
  end
end

def part1
  dots = $lines.take_while { |l| l != "" }.map { |l| Point.new(*l.split(',', 2).map(&:to_i)) }
  folds = $lines.grep(/fold/).flat_map { |l| l.scan(/along ([xy])=(\d+)/)}

  height, width =dots.map(&:y).max + 1, dots.map(&:x).max + 1
  grid = dots.to_set

  # 0.upto(height.pred) do |y|
  #   0.upto(width.pred) do |x|
  #     print grid[y, x] ? '#' : '.'
  #   end
  #   puts
  # end
  # puts

  grid, width, height = folds[0, 1].reduce([grid, width, height]) do |(grid, width, height), fold|
    fold(grid, fold, width, height).tap do |grid, width, height|
      # 0.upto(height.pred) do |y|
      #   0.upto(width.pred) do |x|
      #     print grid.include?(Point.new(x, y)) ? '#' : '.'
      #   end
      #   puts
      # end
      # puts
    end
  end


  grid.count
end

def part2
  dots = $lines.take_while { |l| l != "" }.map { |l| Point.new(*l.split(',', 2).map(&:to_i)) }
  folds = $lines.grep(/fold/).flat_map { |l| l.scan(/along ([xy])=(\d+)/)}

  height, width =dots.map(&:y).max + 1, dots.map(&:x).max + 1
  grid = dots.to_set

  grid, width, height = folds.reduce([grid, width, height]) do |(grid, width, height), fold|
    fold(grid, fold, width, height)
  end
  0.upto(height.pred) do |y|
    0.upto(width.pred) do |x|
      print grid.include?(Point.new(x, y)) ? '#' : '.'
    end
    puts
  end
  puts
end

pp part1
pp part2

__END__
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5