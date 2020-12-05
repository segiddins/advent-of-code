#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")

def row(str)
    (?0 + str.tr(?F, ?0).tr(?B, ?1)).to_i(2)
end

def column(str)
    str.tr(?L, ?0).tr(?R, ?1).to_i(2)
end

def seat_id(str)
    r = row(str[0, 7])
    c = column(str[7, 3])

    r * 8 + c
end

def part1
    $input_lines.map { |l| seat_id(l) }.max
end

def part2
    ids = $input_lines.map { |l| seat_id(l) }.to_set
    0.upto(127) do |row|
        0.upto(8) do |col|
            i = row * 8 + col
            return i if !ids.include?(i) && ids.include?(i+1) && ids.include?(i-1)
        end
    end
end

pp part1
pp part2

__END__
