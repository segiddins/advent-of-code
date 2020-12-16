#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
rules, mine, nearby = $input.split("\n\n")

$rules = rules.split("\n").map { |r| k, v = r.split(': '); [k, v.split(' or ').map { |l| Range.new(*l.split('-').map(&:to_i)) }] }.to_h
$mine = mine.split("\n")[1].yield_self { |l| l.split(',').map(&:to_i) }
$nearby = nearby.split("\n")[1..-1].map { |l| l.split(',').map(&:to_i) }

def part1
  $nearby.sum do |fs|
    fs.sum do |f|
      if $rules.any? do |_, ranges|
           ranges.any? { |r| r.include?(f) }
         end
        0
      else
        f
end
    end
  end
end

def part2
  tickets = [$mine] + $nearby

  valid = Array.new($mine.size) { $rules.dup }

  tickets.each do |t|
    next unless t.all? do |f|
      $rules.any? do |_, ranges|
        ranges.any? { |r| r.include?(f) }
      end
    end

    t.each_with_index do |f, i|
      valid[i].reject! do |_, ranges|
        ranges.none? { |r| r.include?(f) }
      end
    end
  end

  loop do
    multi = valid.select { |v| v.size > 1 }
    if valid.flat_map { |v| next unless v.size == 1; multi.map { |m| next if m.size == 1; m.delete(v.keys.first) } }.compact.empty?

      break
    end
  end

  pp valid

  valid.each_with_index.reduce(1) do |acc, (h, i)|
    k = h.keys[0]
    next acc unless k.start_with?('departure')

    acc * $mine[i]
  end
end

pp part1
pp part2

__END__
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
