#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  $lines.sum do |l|
    s = []
    corrupted = nil
    pairs = { '{' => '}', '<' => '>', '[' => ']', '(' => ')' }

    l.chars.each do |c|
      case c
      when *pairs.keys
        s << c
      when *pairs.values
        p = s.pop
        if c != pairs[p]
          corrupted = c
          break
        end
      else
        raise "unexpected #{c} in #{l}"
      end
    end

    # next 0 unless s.empty? && !corrupted

    { nil => 0, ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }[corrupted]
  end
end

def part2
  $lines
    .map do |l|
      s = []
      corrupted = nil
      pairs = { '{' => '}', '<' => '>', '[' => ']', '(' => ')' }

      l.chars.each do |c|
        case c
        when *pairs.keys
          s << c
        when *pairs.values
          p = s.pop
          if c != pairs[p]
            corrupted = c
            break
          end
        else
          raise "unexpected #{c} in #{l}"
        end
      end

      next 0 if corrupted

      s
        .reverse_each
        .reduce(0) do |acc, elem|
          v = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }
          acc * 5 + v.fetch(pairs[elem])
        end
    end
    .-([0])
    .sort
    .median
end

pp part1
pp part2

__END__
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
