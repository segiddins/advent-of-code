#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
$input = DATA.read
$lines = $input.split("\n")

def part1
  crabs = $lines.first.split(?,).map(&:to_i)
  pos = crabs.median
  crabs.sum { |c| (c-pos).abs }
end

def part2
  cost = ->(c, pos) { (c-pos).abs * (c-pos).abs.+(1) / 2 }
  crabs = $lines.first.split(?,).map(&:to_i).sort
  pos = crabs.map(&:to_f).mean
  [crabs.sum { |c| cost[c, pos.floor] }, crabs.sum { |c| cost[c, pos.ceil] }].min
end

pp part1
pp part2

__END__
16,1,2,0,4,2,7,1,2,14
