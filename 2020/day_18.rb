#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")

def ev(s)
  if s.include?('(')
    ev s.gsub(/\(([^\(]+?)\)/) { |m| ev m[1..-2] }
  else
    stack = s.split(' ')
    stack.reduce do |acc, elem|
      case acc
      when Proc
        acc[elem.to_i]
      else
        ->(e) { acc.to_i.send(elem, e.to_i) }
      end
    end
  end
end

def part1
  $input_lines.sum { |l| ev l }
end

def ev2(s)
  if s.include?('(')
    ev2 s.gsub(/\(([^\(]+?)\)/) { |m| ev2 m[1..-2] }
  else
    (s = s.sub(/\d+ \+ \d+/) { |m| eval(m) }) while s.include?('+')

    stack = s.split(' ')
    stack.reduce do |acc, elem|
      case acc
      when Proc
        acc[elem.to_i]
      else
        ->(e) { acc.to_i.send(elem, e.to_i) }
      end
    end.to_i
  end
end

def part2
  $input_lines.sum { |l| ev2 l }
end

pp part1
pp part2

__END__
1 + 2 * 3 + 4 * 5 + 6
1 + (2 * 3) + (4 * (5 + 6))
2 * 3 + (4 * 5)
5 + (8 * 3 + 9 + 3 * 4 * 3)
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
