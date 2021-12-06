#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  fish = $lines[0].split(?,).map(&:to_i)
  (1..80).each do |d|
    nf = []
    fish = fish.map { |f| f.zero? ? (nf << 8 and 6) : f.pred } + nf
  end
  fish.count
end

def part2
  fish = $lines[0].split(?,).map(&:to_i).group_by(&:itself).transform_values(&:count)
  (1..256).each do |d|
    nf = fish.delete(0) || 0
    fish = fish.transform_keys(&:pred)
    fish[8] = nf
    fish[6] ||= 0
    fish[6] += nf
  end
  fish.sum(&:last)
end


pp part1
pp part2

__END__
3,4,3,1,2
