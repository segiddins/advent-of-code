#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n").map(&:to_i)

pp $lines.each_cons(2).count { |a, b| b > a }
pp $lines.each_cons(3).map(&:sum).each_cons(2).count { |a, b| b > a }

__END__
199
200
208
210
200
207
240
269
260
263
