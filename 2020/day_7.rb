#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")

$rules = $input_lines.map do |l|
  bag, c = l.split ' bags contain '
  c.chomp!('.')
  next [bag, []] if c == 'no other bags'

  [bag, c.split(',').map { |a| a =~ /(\d+) (.+) bags?/; [Regexp.last_match(1), Regexp.last_match(2)] }]
end.to_h

r = $rules.dup
require 'tsort'
$bags = TSort.tsort(
  ->(&b) { r.each_key(&b) },
  ->(a, &b) { r.fetch(a).map(&:last).each(&b) }
)

def part1
  h = { 'shiny gold' => true }

  $bags.each do |b|
    h[b] ||= $rules[b].any? { |_, a| h[a] }
  end

  h.count { |_, v| v } - 1
end

def part2
  h = {}
  $bags.each do |b|
    h[b] = 1 + $rules[b].sum { |c, a| h.fetch(a) * c.to_i }
  end
  h['shiny gold'] - 1
end

pp part1
pp part2

__END__
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
