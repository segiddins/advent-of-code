#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def print_grid(cukes, max_x, max_y)
  0.upto(max_y) do |y|
    0.upto(max_x) { |x| print cukes[Point.new(x, y)] }
    puts
  end
  puts
  cukes
end

def move(cukes, max_x, max_y)
  nc = cukes.dup

  right = ->(pt) { Point.new(pt.x == max_x ? 0 : pt.x + 1, pt.y) }
  down = ->(pt) { Point.new(pt.x, pt.y == max_y ? 0 : pt.y + 1) }

  has_changes = false

  east_facing = []
  south_facing = []

  cukes.each { |pt, v| v == '>' ? east_facing << pt : south_facing << pt }

  east_facing.each do |pt|
    r = right[pt]
    next if cukes.key?(r)

    has_changes = true
    nc[r] = '>'
    nc.delete(pt)
  end
  cukes = nc.dup

  south_facing.each do |pt|
    d = down[pt]
    next if cukes.key?(d)

    has_changes = true
    nc[d] = 'v'
    nc.delete(pt)
  end

  return nc, has_changes
end

def part1
  cukes = {}
  $lines.each_with_index do |l, y|
    l.chars.each_with_index { |c, x| cukes[Point.new(x, y)] = c }
  end

  max_x = cukes.each_key.map(&:x).max
  max_y = cukes.each_key.map(&:y).max
  cukes.delete_if { |_, v| v == '.' }

  iters = 0
  loop do
    nc, has_changes = move(cukes, max_x, max_y)
    iters += 1
    break unless has_changes

    cukes = nc
  end

  iters
end

def part2; end

pp part1
pp part2

__END__
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
