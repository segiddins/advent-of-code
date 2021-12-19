#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  map = {}
  height, width = $lines.size, $lines.first.size

  $lines.each_with_index do |l, y|
    l.chars.each_with_index { |h, x| map[Point.new(x + 1, y + 1)] = h.to_i }
  end

  map
    .select do |pt, h|
      pt
        .non_diag_neighbors(1, min_x: 1, min_y: 1, max_x: width, max_y: height)
        .all? { |n| map[n] > h }
    end
    .sum { |_, h| h + 1 }
end

def part2
  map = {}
  height, width = $lines.size, $lines.first.size

  $lines.each_with_index do |l, y|
    l.chars.each_with_index { |h, x| map[Point.new(x + 1, y + 1)] = h.to_i }
  end

  lows =
    map.select do |pt, h|
      pt
        .non_diag_neighbors(1, min_x: 1, min_y: 1, max_x: width, max_y: height)
        .all? { |n| map[n] > h }
    end

  basins =
    lows.map do |pt, _|
      b = Set.new
      v = ->(p) do
        h = map[p]
        return if h == 9 || !b.add?(p)

        p
          .non_diag_neighbors(
            1,
            min_x: 1,
            min_y: 1,
            max_x: width,
            max_y: height
          )
          .select { |n| map[n] > h }
          .each(&v)
      end
      v[pt]
      b
    end

  basins.map(&:size).sort[-3..-1].reduce(&:*)
end

pp part1
pp part2

__END__
2199943210
3987894921
9856789892
8767896789
9899965678
