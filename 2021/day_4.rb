#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")
$ns = $lines.first.split(',').map(&:to_i)
$boards =
  $lines[2..-1]
    .join("\n")
    .split("\n\n")
    .map { |b| b.split("\n").map { |l| l.strip.split(/\s+/).map(&:to_i) } }

def win?(board, nums)
  board.any? { |l| l.all? { |x| nums.include?(x) } } ||
    Matrix
      .rows(board)
      .transpose
      .to_a
      .any? { |l| l.all? { |x| nums.include?(x) } }
end

def part1
  1.upto($ns.size) do |l|
    s = Array($ns[0, l])
    $boards.each { |b| return b.flatten(1).-(s).sum * s.last if win?(b, s) }
  end
  nil
end

def part2
  bs = $boards.dup
  1.upto($ns.size) do |l|
    s = Array($ns[0, l])
    if bs.size == 1 && win?(bs.first, s)
      return bs.first.flatten(1).-(s).sum * s.last
    end
    bs.reject! { |b| win?(b, s) }
  end
  nil
end

pp part1
pp part2

__END__
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
