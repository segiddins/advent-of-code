#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def r(s)
  i = 0
  is_2p = false
  depth = 0

  loop do
    case (left = s[i])
    when nil
      return s if is_2p

      i = 0
      is_2p = true
      depth = 0
      next
    when '['
      depth += 1
    when ']'
      depth -= 1
    when Integer


      if depth > 4 && (right = s[i+2]).is_a?(Integer)
        pred = s[0, i-1]
        succ = s[(i+3)..-1]

        l = pred.rindex { |e| e.is_a?(Integer) }
        pred[l] = s[l] + left if l
        r = succ&.index { |e| e.is_a?(Integer) }
        succ[r] = succ[r] + right if r
        succ[0] = 0

        s = pred + succ
        i = 0
        is_2p = false
        depth = 0
        next
      elsif is_2p and left >= 10
        pred = s[0, i]
        succ = s[(i+1)..-1]

        half = left / 2.0
        left = half.floor
        right = half.ceil

        s = pred + ['[', left, ',', right, ']'] + succ
        i = 0
        is_2p = false
        depth = 0
        next
      end
    end
    i += 1
  end
end

def mag(s)
  s = s.join
  loop do
    return s.to_i unless s.sub!(/\[(\d+),(\d+)\]/) { ($1.to_i * 3 + $2.to_i * 2).to_s }
  end
end

def part1
  $lines.map do |l|
    l.scan(/[\[\],]|\d+/).map {|e| e =~ /\d+/ ? e.to_i : e }
  end.reduce do |acc, elem|
    r(%w([) + acc + [','] + elem + [']'])
  end.yield_self(&method(:mag))
end

def part2
  $lines.map do |l|
    s = l.scan(/[\[\],]|\d+/).map {|e| e =~ /\d+/ ? e.to_i : e }
  end.permutation(2).map do |l, r|
    mag r(%w([) + l + [','] + r + [']'])
  end.max
end

pp part1
pp part2

__END__
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]