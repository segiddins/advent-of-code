#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")#.map { |l| l =~ /(.)(\d+)/; [Regexp.last_match(1), Regexp.last_match(2).to_i] }
$early = $input_lines.first.to_i
$buses = $input_lines.last.split(',').map(&:to_i)

def part1
  departures = []
  $buses.reject {|s| s == 'x' }.each do |b|
    0.upto($early) do |m|
      departures << [b, b * m]
    end
  end
  b, d = departures.reject { |_, d| d < $early }.min_by(&:last)
  b * (d - $early)
end

def part2
  chr_o = -1
  $buses.each_with_index.map { |b, i| next if b.zero?; "#{b}#{('a'.ord + (chr_o += 1)).chr} - #{i}"}.compact.join(' == ')

  # plug into wolfram alpha
  783685719679632
end

pp part1
pp part2

__END__
939
7,13,x,x,59,x,31,19
