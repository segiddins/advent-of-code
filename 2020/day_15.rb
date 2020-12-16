#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")[0].split(',').map(&:to_i)

def nth(nth)
  spoken = {}
  $input_lines.each_with_index { |n, i| spoken[n] = i + 1 }
  turn = $input_lines.size
  last_spoken = $input_lines.last
  loop do
    last_seen = spoken[last_spoken]
    next_spoken = if last_seen && last_seen < turn
                    turn - last_seen
                  else
                    0
                  end

    spoken[last_spoken] = turn
    return last_spoken if turn == nth

    last_spoken = next_spoken

    turn += 1
  end
end

def part1
  nth(2020)
end

def part2
  nth(30_000_000)
end

pp part1
pp part2

__END__
0,3,6
