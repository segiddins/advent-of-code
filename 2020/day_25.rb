#!/usr/bin/env ruby

require_relative '../aoc'
require 'openssl'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$k1, $k2 = $input.split("\n").map(&:to_i)
$mod = 20_201_227

def part1
  k1 = nil
  k2 = nil
  v = 1
  1.upto(50_000_000) do |ls|
    v *= 7
    v %= $mod
    k1 = ls if v == $k1
    k2 = ls if v == $k2
    break if k1 || k2
  end
  k1 ? $k2.to_bn.mod_exp(k1, $mod).to_i : $k1.to_bn.mod_exp(k2, $mod).to_i
end

def part2; end

pp part1
pp part2

__END__
5764801
17807724
