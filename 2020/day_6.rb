#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n\n")
$groups = $input_lines.map { |g| g.split("\n").flat_map(&:chars).to_set }
$groups2 = $input_lines.map { |g| g.split("\n").map { |l| l.chars.to_set }.reduce(&:&) }


def part1
    $groups.sum(&:count)
end

def part2
    $groups2.sum(&:count)
end

pp part1
pp part2

__END__
abc

a
b
c

ab
ac

a
a
a
a

b
