#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")


def mask(m, n)
  n = n.to_s(2).rjust(36, ?0)
  m.chars.each_with_index do |c, i|
    next if c == ?X
    n[i] = c
  end
  n.to_i(2)
end

def part1
  mem = {}
  mask = ''
  $input_lines.each do |l|
    case l
    when /mask = (.+)/
      mask = $1
    when /mem\[(\d+)\] = (\d+)/
      mem[$1.to_i] = mask(mask, $2.to_i)
    end
  end
  mem.each_value.sum
end

def mask2(m, n)
  n = n.to_s(2).rjust(36, ?0)
  fl = []
  m.chars.each_with_index do |c, i|
    next if c == ?0
    fl << i if c == ?X
    n[i] = c
  end
  0.upto(fl.size).flat_map do |c|
    fl.combination(c).
      map { |i| a = n.dup; i.each { |d| a[d] = '1' }; (fl - i).each { |d| a[d] = '0' }; a }.map { |g| g.to_i(2)}
  end.sort
end

def part2
  mem = {}
  mask = ''
  $input_lines.each do |l|
    case l
    when /mask = (.+)/
      mask = $1
    when /mem\[(\d+)\] = (\d+)/
      mask2(mask, $1.to_i).each do |addr|
        mem[addr] = $2.to_i
      end
    end
  end
  mem.each_value.sum
end

pp part1
pp part2

__END__
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
