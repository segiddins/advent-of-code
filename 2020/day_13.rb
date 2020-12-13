#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")
$early = $input_lines.first.to_i
$buses = $input_lines.last.split(',').map(&:to_i)

def part1
  buses = $buses.reject(&:zero?)
  bus, departure = buses.map { |b| [b, ($early.to_f / b).ceil * b] }.min_by(&:last)
  bus * (departure - $early)
end

def mod_inverse(b, mod)
  if b.gcd(mod) != 1
    raise 'Inverse does not exist'
  else
    (b**(mod - 2)) % mod
  end
end

def mod_divide(num, denom, mod)
  num = num % mod
  inverse = mod_inverse(denom, mod)
  (inverse * num) % mod
end

def part2
  chr_o = -1
  eqn = $buses.each_with_index.map do |b, i|
    next if b.zero?

    [b, ('a'.ord + (chr_o += 1)).chr, -i]
  end.compact

  f, *rest = eqn
  coeff = rest.map do |rhs|
    a_0, b_0, c_0 = *f
    a_1, b_1, c_1 = *rhs

    b_0_v = mod_divide(c_1 - c_0, a_0, a_1)
    b_1_v = mod_divide(c_0 - c_1, a_1, a_0)

    [b_0_v, a_1]
  end

  prod = coeff.map(&:last).reduce(&:*)
  a = coeff.sum { |res, mod| res * mod_inverse(prod / mod, mod) * prod / mod } % prod
  a * f[0] + f[2]
end

pp part1
pp part2

__END__
939
7,13,x,x,59,x,31,19
