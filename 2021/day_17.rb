#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def height(xv, yv, x1, x2, y1, y2)
  px, py = 0, 0

  max_y = 0

  loop do
    # puts "(#{px}, #{py})"
    px += xv
    py += yv

    if xv > 0
      xv -= 1
    elsif xv < 0
      xv += 1
    end
    yv -= 1


    max_y = [max_y, py].max
    break if px <= x2 and px >= x1 and py <= y2 and py >= y1
    return if px > x2 or py < y1
  end
  max_y
end

def part1
  x1, x2, y1, y2 = $lines.first.scan(/x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/).first.map(&:to_i)


  max_h = 0
  1.upto(x2) do |vx|
    1.upto(-y1) do |vy|
      max_h = [max_h, height(vx, vy, x1, x2, y1, y2)].compact.max
    end
  end
  max_h
end

def part2
  x1, x2, y1, y2 = $lines.first.scan(/x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/).first.map(&:to_i)


  1.upto(x2).sum do |vx|
    y1.upto(-y1).count do |vy|
      !height(vx, vy, x1, x2, y1, y2).nil?
    end
  end
end

pp part1
pp part2

__END__
target area: x=20..30, y=-10..-5