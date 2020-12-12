#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n").map { |l| l=~/(.)(\d+)/; [$1, $2.to_i] }

def part1
  pos  = 0i
  dir = 1+0i

  $input_lines.each do |a, c|
    case a
    when 'N'
        pos += c * 1i
    when 'S'
        pos -= c * 1i
    when 'E'
        pos += c
    when 'W'
        pos -= c
    when 'L'
        dir *= (Math::E + 0i) **  (1i * c * Math::PI / 180.0)
    when 'R'
        dir *= (Math::E + 0i) ** (-1i * c * Math::PI / 180.0)
    when 'F'
        pos += dir * c
    end
  end

  pos.real.abs + pos.imag.abs
end

def part2
  waypos = 10 + 1i
  pos  = 0i

  $input_lines.each do |a, c|
    case a
    when 'N'
        waypos += c * 1i
    when 'S'
        waypos -= c * 1i
    when 'E'
        waypos += c
    when 'W'
        waypos -= c
    when 'L'
        waypos = pos + (waypos - pos) * (Math::E + 0i) ** (1i * c * Math::PI / 180.0)
    when 'R'
        waypos = pos + (waypos - pos) * (Math::E + 0i) ** (-1i * c * Math::PI / 180.0)
    when 'F'
        w = waypos - pos
        pos += (waypos - pos) * c
        waypos = pos + w
    end
  end

  pos.real.abs + pos.imag.abs
end

pp part1
pp part2

__END__
F10
N3
F7
R90
F11
