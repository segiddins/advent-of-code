#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")
$bin = $lines.map { |l| l.chars.map(&:to_i) }

def part1
  size = $bin.first.count
  n =
    Array.new(size) do |x|
      $bin.map { |a| a[x] }.group_by(&:itself).max_by { |a, b| b.count }.first
    end
  e = n.map { |x| (1 - x) }.join.to_i(2)
  g = n.join.to_i(2)
  pp e * g
end

def part2
  size = $bin.first.count
  o = $bin.dup
  c = $bin.dup
  size.times do |x|
    mc =
      o.map { |a| a[x] }.group_by(&:itself).max_by { |a, b| [b.count, a] }.first
    lc =
      c.map { |a| a[x] }.group_by(&:itself).min_by { |a, b| [b.count, a] }.first
    o = o.select { |a| a[x] == mc } if o.size > 1
    c = c.select { |a| a[x] == lc } if c.size > 1
  end
  pp o.join.to_i(2) * c.join.to_i(2)
end

part1
part2

__END__
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
