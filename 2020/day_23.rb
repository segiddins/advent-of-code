#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$cups = $input.strip.chars.map(&:to_i)

N = Struct.new(:val, :next) do
  alias_method :hash, :val
  alias_method :==, :equal?
  alias_method :eql?, :equal?
end

def m(times, cups)
  max = cups.max
  all = {}
  curr = N.new(cups.shift, nil)
  all[curr.val] = curr
  last = cups.reduce(curr) do |acc, elem|
    acc.next = N.new(elem, nil).yield_self { |n| all[elem] = n }
  end
  last.next = curr

  times.times do |_i|
    succ = curr.next
    succ_v = [succ.val]
    succ_e = succ
    2.times { succ_e = succ_e.next.tap { |s| succ_v << s.val } }
    curr.next = succ_e.next

    dc = curr.val == 1 ? max : curr.val.pred
    while succ_v.include?(dc)
      dc -= 1
      dc = max if dc < 1
    end

    succ_e.next = all[dc].next
    all[dc].next = succ

    curr = curr.next
  end

  i = all[1].next
  a = []
  loop do
    break if i.val == 1

    a << i.val
    i = i.next
  end

  a
end

def part1
  cups = $cups.dup
  cups = m(100, cups)
  cups.join
end

def part2
  cups = $cups.dup
  m = cups.max
  cups << (m += 1) until cups.size == 1_000_000

  cups = m(10_000_000, cups)

  cups[0, 2].reduce(1, &:*)
end

pp part1
pp part2

__END__
389125467
