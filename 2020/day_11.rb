#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n").map(&:chars) # .map(&:to_i)

def run(s, part:)
  Array.new(s.size) do |r|
    Array.new(s[0].size) do |c|
      now = s.dig(r, c)
      count = -1.upto(1).sum do |x|
        -1.upto(1).sum do |y|
          mul = 1
          loop do
            r_ = r + x * mul
            c_ = c + y * mul
            break 0 if x == 0 && y == 0 || (r_ < 0 || c_ < 0)

            n_ = s.dig(r_, c_)
            break 0 if n_.nil?
            break 0 if n_ == 'L'
            break 1 if n_ == '#'
            break 0 if part == 1

            mul += 1
          end
        end
      end

      case now
      when '.'
        now
      when 'L'
        count == 0 ? '#' : now
      when '#'
        if count >= (part == 1 ? 4 : 5)
          'L'
        else
          now
end
      end
    end
  end
end

def part1
  s = $input_lines
  loop do
    ss = run(s, part: 1)
    return ss.to_s.count('#') if ss == s

    s = ss
  end
end

def part2
  s = $input_lines
  loop do
    ss = run(s, part: 2)
    return ss.to_s.count('#') if ss == s

    s = ss
  end
end

pp part1
pp part2

__END__
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
