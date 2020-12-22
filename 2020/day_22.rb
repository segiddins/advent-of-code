#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$players = $input.split("\n\n").map { |s| [s.lines[0].split(/ |:/)[1], s.lines[1..-1].map(&:to_i)] }.to_h

def c(decks)
  decks = decks.transform_values(&:dup)
  loop do
    break if decks.each_value.any?(&:empty?)

    c1, c2 = *decks.each_value.map(&:shift)

    if c1 > c2
      decks['1'].concat [c1, c2]
    else
      decks['2'].concat [c2, c1]
    end
  end
  decks
end

def part1
  c($players).each_value.sum { |d| d.reverse_each.each_with_index.sum { |c, i| c * i.succ } }
end

def rc(d1, d2)
  seen = Set.new

  loop do
    break if d1.empty? || d2.empty?

    k = [d1.dup, d2.dup]
    break d2 = [] unless seen.add?(k)

    c1 = d1.shift
    c2 = d2.shift

    if d1.size >= c1 && d2.size >= c2
      r = rc(d1[0, c1], d2[0, c2])
      if r[0]
        d1.concat [c1, c2]
      else
        d2.concat [c2, c1]
      end
    else
      if c1 > c2
        d1.concat [c1, c2]
      else
        d2.concat [c2, c1]
      end
    end
  end

  [d1, d2].map { |v| v.empty? ? nil : v }
end

def part2
  rc(*$players.sort_by(&:first).map(&:last)).compact.sum { |d| d.reverse_each.each_with_index.sum { |c, i| c * i.succ } }
end

pp part1
pp part2

# pp $states.group_by(&:itself).transform_values(&:count).sort_by(&:last)

__END__
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
