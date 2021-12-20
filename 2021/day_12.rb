#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

LARGE = Hash.new { |h, k| h[k] = k == k.upcase }

def visit(pt, t, seen, graph, pt1)
  return [] if t.empty? && pt != 'start'
  w_pt = t.map { |path| path + [pt] }
  return w_pt if pt == 'end'

  unless LARGE[pt]
    w_pt.delete_if do |path|
      dups = path.group_by(&:itself).select { |k, v| v.size > 1 && !LARGE[k] }
      dups.size > (pt1 ? 0 : 1) || dups.each_value.any? { |v| v.size > 2 } ||
        !seen.add?(path)
    end
  end

  succ = graph[pt]

  succ.flat_map { |s| visit(s, w_pt, seen, graph, pt1) }
end

def part1
  graph = {}
  $lines.each do |l|
    a, b = l.split('-', 2)
    (graph[a] ||= []) << b
    (graph[b] ||= []) << a
  end
  graph['end'] = []
  graph.each_value { |v| v.delete('start') }

  visit('start', [[]], Set.new, graph, true).sort.map { |i| i.join(',') }.size
end

def part2
  graph = {}
  $lines.each do |l|
    a, b = l.split('-', 2)
    (graph[a] ||= []) << b
    (graph[b] ||= []) << a
  end
  graph['end'] = []
  graph.each_value { |v| v.delete('start') }

  visit('start', [[]], Set.new, graph, false).sort.map { |i| i.join(',') }.size
end

pp part1
pp part2

__END__
start-A
start-b
A-c
A-b
b-d
A-end
b-end
