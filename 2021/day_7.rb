#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  crabs = $lines.first.split(?,).map(&:to_i)
  min,max = crabs.minmax
  pos = (min..max).min_by { |pos| crabs.sum { |c| (c-pos).abs } }
  crabs.sum { |c| (c-pos).abs }
end

def part2

  cost = ->(c, pos) { (c-pos).abs * (c-pos).abs.succ / 2 }
  crabs = $lines.first.split(?,).map(&:to_i)
  min,max = crabs.minmax
  pos = (min..max).min_by { |pos| crabs.sum { |c| cost[c, pos] } }
  crabs.sum { |c| cost[c, pos] }
end


pp part1
pp part2

__END__
16,1,2,0,4,2,7,1,2,14
