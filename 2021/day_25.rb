#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def print_grid(cukes, max_x, max_y)
  0.upto(max_y) do |y|
  0.upto(max_x) do |x|
    print cukes[Point.new(x, y)]
  end
  puts
end
puts
cukes
end

def move(cukes, max_x, max_y)
  nc = cukes.dup

  right = ->(pt) { Point.new(pt.x.succ % max_x.succ, pt.y) }
  down = ->(pt) { Point.new(pt.x, pt.y.succ % max_y.succ) }

  east_facing = cukes.select { |_, v| v == '>' }
  east_facing.each_key do |pt|
    r = right[pt]
    next unless cukes[r] == '.'

    nc.merge!(r => '>', pt => '.')
  end
  cukes = nc.dup

  south_facing = cukes.select { |_, v| v == 'v' }
  south_facing.each_key do |pt|
    d = down[pt]
    next unless cukes[d] == '.'

    nc.merge!(d => 'v', pt => '.')
  end

  nc
end

def part1
  cukes = {}
  $lines.each_with_index do |l, y|
    l.chars.each_with_index do |c, x|
      cukes[Point.new(x, y)] = c
    end
  end

  max_x = cukes.each_key.map(&:x).max
  max_y = cukes.each_key.map(&:y).max

  iters = 0
  loop do
    # puts iters
    # print_grid(cukes, max_x, max_y)
    nc = move(cukes, max_x, max_y)
    iters += 1
    break if nc == cukes

    cukes = nc
  end

  iters
end

def part2
end

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