#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def fold(template, subs)
  template.chars.each_cons(2).flat_map do |a, b|
    [a, subs[a+b]].compact
  end.join << template[-1]
end

def part1
  template = $lines.first
  subs = $lines[2..-1].map { |l| l.split(' -> ', 2) }.to_h

  10.times { template = fold(template, subs) }
  freqs = template.chars.group_by(&:itself).transform_values(&:count).sort_by(&:last)
  freqs.last.last - freqs.first.last
end

def part2
  template = $lines.first
  subs = $lines[2..-1].map { |l| l.split(' -> ', 2) }.to_h

  pairs = template.chars.each_cons(2).to_a.map(&:join).group_by(&:itself).transform_values(&:count)

  succ = subs.map do |s, v|
    a = s
    a = fold(a, subs)
    [s, a.chars.each_cons(2).to_a.map(&:join)]
  end.to_h

  40.times do
    np = Hash.new { |h, k| h[k] = 0 }
    pairs.each do |k, v|
      succ[k].each { |p| np[p] += v }
    end
    pairs = np
  end

  freq = Hash.new { |h, k| h[k] = 0 }
  pairs.each {|k, v| k.chars.each {|c| freq[c] += v } }
  freq.transform_values! { |v| v % 2 == 0 ? v / 2 : v / 2 + 1 } 

  -freq.sort_by(&:last).values_at(0, -1).map(&:last).reduce(&:-)

  # 40.times { template = fold(template, subs) }
  # freqs = template.chars.group_by(&:itself).transform_values(&:count).sort_by(&:last)
  # freqs.last.last - freqs.first.last
end

pp part1
pp part2

__END__
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C