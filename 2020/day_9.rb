#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$n = 25
$input_lines = $input.split("\n").map(&:to_i)

def part1
  n = $n
  $input_lines.count.-(n).times do |b|
    a = $input_lines[b, n]
    s = $input_lines[b + n]
    next if a.combination(2).any? do |c|
      c.sum == s
    end

    return s
  end
  abort 'none found'
end

def part2
  s = part1
  i = 0
  loop do
    j = 1
    loop do
      sub = $input_lines[i, j]
      break if sub.count != j
      return sub.minmax.sum if sub.sum == s

      j += 1
    end
    i += 1
  end
  abort 'not'
end

pp part1
pp part2

__END__
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
