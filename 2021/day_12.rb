#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

LARGE = Hash.new { |h, k| h[k] = k == k.upcase }

def invalid(path, pt1)
  seen = []
  dup = nil
  path.find do |elt|
    next if LARGE[elt]
    ct = seen.count(elt)
    if ct > 0
      next true if pt1 || dup
      dup = elt
    end
    seen << elt
    false
  end
end

def visit(pt, t, graph, pt1)
  w_pt = t.map { |path| path + [pt] }
  return w_pt if pt == 'end'

  unless LARGE[pt]
    w_pt.delete_if { |path| invalid(path, pt1) }
    return [] if w_pt.empty?
  end

  graph[pt].flat_map { |s| visit(s, w_pt, graph, pt1) }
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

  visit('start', [[]], graph, true).size
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

  visit('start', [[]], graph, false).size
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
