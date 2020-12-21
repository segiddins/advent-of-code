#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")
$recipes = $lines.map { |l| ing, all, = l.split(/ \(contains |\)/); [ing.split(' '), all.split(', ')] }

def part1
  all = Hash.new { |h, k| h[k] = [] }
  $recipes.each do |ing, a|
    a.each { |e| all.key?(e) ? all[e] &= ing : all[e] = ing }
  end
  ($recipes.map(&:first).reduce(&:+) - all.values.reduce(&:+)).size
end

def part2
  all = Hash.new { |h, k| h[k] = [] }
  $recipes.each do |ing, a|
    a.each { |e| all.key?(e) ? all[e] &= ing : all[e] = ing }
  end
  canon = {}
  loop do
    a, i = all.find { |_, v| v.size == 1 }
    break unless a

    i = i[0]

    canon[a] = i

    all.delete(a)
    all.each_value { |v| v.delete(i) }
  end
  canon.sort_by(&:first).map(&:last).join(',')
end

pp part1
pp part2

__END__
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
