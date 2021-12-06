#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")
$inst = $lines.map { |l| a,b = l.split(' ', 2); [a, b.to_i] }

Pt = Struct.new(:x, :z, :aim)

def part1
  pos = Pt.new(0,0)
  $inst.each do |a,b|
    case a
    when 'forward'
      pos.x += b
    when 'down'
      pos.z += b
    when 'up'
      pos.z -= b
    end
  end

  pp pos.x * pos.z
end

def part2
  pos = Pt.new(0,0, 0)
  $inst.each do |a,b|
    case a
    when 'forward'
      pos.x += b
      pos.z += pos.aim * b
    when 'down'
      pos.aim += b
    when 'up'
      pos.aim -= b
    end
  end

  pp pos.x * pos.z
end


part1
part2

__END__
forward 5
down 5
forward 8
up 3
down 8
forward 2