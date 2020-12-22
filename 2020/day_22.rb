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

def rc(decks)
  decks = decks.transform_values(&:dup)
  seen = Set.new

  loop do
    return { '1' => decks['1'] } unless seen.add?(decks.transform_values(&:dup))
    break if decks.each_value.any?(&:empty?)

    c1, c2 = *decks.each_value.map(&:shift)

    if decks['1'].size >= c1 && decks['2'].size >= c2
      r = rc({ '1' => decks['1'][0, c1], '2' => decks['2'][0, c2] })
      if r['1']
        decks['1'].concat [c1, c2]
      else
        decks['2'].concat [c2, c1]
      end
    else
      if c1 > c2
        decks['1'].concat [c1, c2]
      else
        decks['2'].concat [c2, c1]
      end
    end
  end

  decks.reject { |_k, v| v.empty? }
end

def part2
  rc($players).each_value.sum { |d| d.reverse_each.each_with_index.sum { |c, i| c * i.succ } }
end

pp part1
pp part2

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
