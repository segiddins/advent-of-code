#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")

$map = {}.tap do |map|
  $input_lines.each_with_index do |row, r|
    row.chars.each_with_index do |a, c|
      next unless a == '#'

      map[[r, c]] = true
    end
  end
end.freeze

NEIGHBORS = Hash.new do |h, ndim|
  h[ndim] = 1.upto((3**ndim).pred).map do |idx|
    s = idx.to_s(3)
    Array.new(ndim) { |i| case s[-i - 1] when '1' then 1 when '2' then -1 else 0 end }.freeze
  end.freeze
end

def each_around(pt, size)
  return enum_for(__method__, pt, size) unless block_given?

  NEIGHBORS[size].each do |n|
    yield Array.new(size) { |i| pt[i] + n[i] }
  end
end

def mirrored(pt)
  Array.new(pt.size) { |i| i < 2 ? pt[i] : pt[i].abs }
end

def run(ndim:)
  map = $map.transform_keys { |k| k + [0] * (ndim - k.length) }

  6.times do
    nm = Hash.new { |h, k| h.fetch(mirrored(k), false) }

    neighbors = Hash.new { |h, k| h[k] = Set.new }
    map.each_key do |pt|
      each_around(pt, ndim) do |n|
        nb = neighbors[n]
        nb << pt if nb.size <= 3
      end
    end
    neighbors.each do |pt, n|
      next if pt[2..-1].any? { |d| d < -3 }

      n = n.size
      nm[pt] = true if n == 3 || (n == 2 && map[pt])
    end

    map = nm
  end

  map.each_key.reject { |pt| pt != mirrored(pt) }.sum { |pt| 2**pt[2..-1].count(&:nonzero?) }
end

def part1
  run(ndim: 3)
end

def part2
  run(ndim: 4)
end

pp part1
pp part2
# pp run(ndim: 5)
# pp run(ndim: 6)
# pp run(ndim: 7)
# pp run(ndim: 8)
# pp run(ndim: 9)
# pp run(ndim: 10)

__END__
.#.
..#
###
