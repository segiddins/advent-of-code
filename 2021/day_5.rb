#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  ls = $lines.map { |l| l.match(/(\d+),(\d+) -> (\d+),(\d+)/).to_a.drop(1).map(&:to_i) }
  pts = Hash.new { |h, k| h[k] = 0 }
  ls.each do |x1, y1, x2, y2|
    if x1 == x2
      y1, y2 = [y1, y2].sort
      y1.upto(y2) { |y| pts[Point.new(x1,y)] += 1 }
    elsif y1 == y2
      x1, x2 = [x1, x2].sort
      x1.upto(x2) { |x| pts[Point.new(x,y1)] += 1 }
    end
  end
  pts.count {|k, v| v>=2}
end

def part2
  ls = $lines.map { |l| l.match(/(\d+),(\d+) -> (\d+),(\d+)/).to_a.drop(1).map(&:to_i) }
  pts = Hash.new { |h, k| h[k] = 0 }
  ls.each do |x1, y1, x2, y2|
    if x1 == x2
      y1, y2 = [y1, y2].sort
      y1.upto(y2) { |y| pts[Point.new(x1,y)] += 1 }
    elsif y1 == y2
      x1, x2 = [x1, x2].sort
      x1.upto(x2) { |x| pts[Point.new(x,y1)] += 1 }
    else
      x1, x2, y1, y2 = x2, x1, y2, y1 if x1 > x2
      dir = (y2 - y1) / (x2 - x1)
      x1.upto(x2) { |x| pts[Point.new(x, y1 + dir * (x - x1))] += 1 }
    end
  end
  # puts
  # 0.upto(9).each do |y|
  #   0.upto(9).each do |x|
  #     print (pts[Point.new(x, y)] || ?.)
  #   end
  #   puts
  # end
  pts.count {|k, v| v>=2}
  # nil
end


pp part1
pp part2

__END__
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
