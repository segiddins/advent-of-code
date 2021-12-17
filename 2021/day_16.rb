#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def read_packet(i)
  version = i.slice!(0, 3).to_i(2)
  tid = i.slice!(0, 3).to_i(2)
  case tid
  when 4
    vs = ''
    i.gsub!(/^(?:1(\d{4}))*(?:0(\d{4}))/) { |m|
      vs = m
      ''
    }
    v = vs.scan(/.(\d{4})/).map do |g|
      g
    end.join.to_i(2)
    {version: version, tid: tid, value: v}
  else
    ltid = i.slice!(0, 1)
    subpackets = 
      if ltid == '0'
        tlib = i.slice!(0, 15).to_i(2)
        exps = i.size - tlib
        sp = []
        while i.size > exps
          sp << read_packet(i)
        end
        sp
      else
        Array.new(i.slice!(0, 11).to_i(2)) {
          read_packet(i)
        }
      end

    value = case tid
    when 0
      subpackets.sum { |s| s[:value] }
    when 1
      subpackets.reduce(1) { |a, e| a * e[:value] }
    when 2
      subpackets.map { |s| s[:value] }.min
    when 3
      subpackets.map { |s| s[:value] }.max
    when 5
      v1, v2 = subpackets.map { |s| s[:value] }
      v1 > v2 ? 1 : 0
    when 6
      v1, v2 = subpackets.map { |s| s[:value] }
      v1 < v2 ? 1 : 0
    when 7
      v1, v2 = subpackets.map { |s| s[:value] }
      v1 == v2 ? 1 : 0
    end
    {version: version, tid: tid, subpackets: subpackets, value: value}
  end
end

def vsum(p)
  p[:version] + Array(p[:subpackets]).sum(&method(:vsum))
end

def part1
  $lines.map do |l|
    i = l.to_i(16).to_s(2)
    while i.size % 4 != 0
      i = '0' + i
    end

    vsum read_packet(i)
  end.first
end

def part2
  $lines.map do |l|
    i = l.to_i(16).to_s(2)
    while i.size % 4 != 0
      i = '0' + i
    end

    read_packet(i)[:value]
  end.first
end

pp part1
pp part2

__END__
8A004A801A8002F478
620080001611562C8802118E34
C0015000016115A2E0802F182340
A0016C880162017C3686B18A3D4780