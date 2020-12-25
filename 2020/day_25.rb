#!/usr/bin/env ruby

require_relative '../aoc'
require 'openssl'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$k1, $k2 = $input.split("\n").map(&:to_i)
$mod = 20_201_227.to_bn

def t(ls, sn)
  sn.to_bn.mod_exp(ls, $mod).to_i
end

def part1
  k1 = nil
  k2 = nil
  1.upto(50_000_000) do |ls|
    v = t(ls, 7)
    k1 = ls if v == $k1
    k2 = ls if v == $k2
    break if k1 || k2
  end
  k1 ? t(k1, $k2) : t(k2, $k1)
end

def part2; end

pp part1
pp part2

__END__
5764801
17807724
