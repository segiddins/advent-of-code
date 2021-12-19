#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

class PriorityQueue
  def initialize
    @h = Hash.new { |h, k| h[k] = [] }
  end
  def <<(e, p)
    @h[p] << e
  end
  def pop
    min_p = @h.each_key.min
    a = @h[min_p]
    a.pop.tap { @h.delete(min_p) if a.empty? }
  end
end
def distance(
  grid,
  start,
  goal,
  came_from = { start => nil },
  cost_so_far = { start => 0 }
)
  to_visit = PriorityQueue.new.tap { |q| q.<<(start, 0) }

  max_x = grid.each_key.map(&:x).max
  max_y = grid.each_key.map(&:y).max

  while current = to_visit.pop
    break if current == goal

    adj =
      current.non_diag_neighbors(
        1,
        min_x: 0,
        min_y: 0,
        max_x: max_x,
        max_y: max_y
      )

    adj.each do |n|
      cost = cost_so_far[current] + grid[n]
      if !came_from.key?(n) || cost < cost_so_far[n]
        cost_so_far[n] = cost
        to_visit.<<(n, cost)
        came_from[n] = current
      end
    end
  end

  d = grid[goal]
  rev_path = [goal]
  while came_from[goal] && goal = came_from[goal]
    rev_path << goal
    d += grid[goal]
  end

  return unless start == goal
  [d - grid[start], rev_path.reverse]
end

def part1
  grid =
    $lines
      .each_with_index
      .flat_map do |l, y|
        l.chars.each_with_index.map { |i, x| [Point.new(x, y), i.to_i] }
      end
      .to_h

  goal = Point.new(grid.each_key.map(&:x).max, grid.each_key.map(&:y).max)

  distance(grid, Point.new(0, 0), goal).first
end

def part2
  grid =
    $lines
      .each_with_index
      .flat_map do |l, y|
        l.chars.each_with_index.map { |i, x| [Point.new(x, y), i.to_i] }
      end
      .to_h

  og_dims =
    Point.new(grid.each_key.map(&:x).max + 1, grid.each_key.map(&:y).max + 1)

  ng = {}
  4.times do |i|
    modified =
      grid.map do |pt, v|
        nv = v + i + 1
        nv = nv % 10 + 1 if nv > 9
        [Point.new(pt.x + og_dims.x * i.succ, pt.y), nv]
      end.to_h
    ng.merge!(modified)
  end
  grid.merge!(ng)
  ng.clear

  4.times do |i|
    modified =
      grid.map do |pt, v|
        nv = v + i + 1
        nv = nv % 10 + 1 if nv > 9
        [Point.new(pt.x, pt.y + og_dims.y * i.succ), nv]
      end.to_h
    ng.merge!(modified)
  end
  grid.merge!(ng)

  goal = Point.new(grid.each_key.map(&:x).max, grid.each_key.map(&:y).max)

  # 0.upto(goal.y.succ) do |y|
  #   0.upto(goal.x.succ) do |x|
  #     print grid[Point.new(x, y)]
  #   end
  #   puts
  # end

  distance(grid, Point.new(0, 0), goal).first
end

pp part1
pp part2

__END__
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
