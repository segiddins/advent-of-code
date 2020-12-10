#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n").map(&:to_i)

def part1
  as = $input_lines.dup.sort

  ([0] + as.sort + [as.max + 3]).each_cons(2).map do |a, b|
    b - a
  end.group_by(&:itself).values_at(1, 3).reduce { |a, b| a.size * b.size }
end

def part2
  og = ([0] + $input_lines.sort + [$input_lines.max + 3]).freeze
  h = {}
  n = lambda do |n1, n2, n3|
    h[[n1, n2, n3]] ||= begin
        if !(n3 < og.size)
          1
        elsif !(og[n3] - og[n2] <= 3)
          1
        elsif !(og[n2] - og[n1] <= 3)
          1
        elsif !(og[n3] - og[n1] <= 3)
          n[n2, n3, n3 + 1]
        else
          n[n1, n3, n3 + 1] + n[n2, n3, n3 + 1]
        end
      end
  end
  n[0, 1, 2]
end

pp part1
pp part2

__END__
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
