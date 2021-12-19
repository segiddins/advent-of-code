#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  graph = {}
  $lines.each do |l|
    a, b = l.split('-', 2)
    (graph[a] ||= []) << b
    (graph[b] ||= []) << a
  end
  graph['end'] = []

  partials = {}
  graph.each do |a, bs|
    (partials[a] ||= Set.new).merge((bs - ['start']).map(&method(:Array)))
  end

  graph.size.times do |i|
    k = 0
    any = false
    partials.each do |a, bs|
      new_ = []
      bs.each do |path|
        partials
          .fetch(path.last)
          .each do |n|
            next if i > 0 and n.last != 'end'
            np = path + n
            next if np.size <= 2**i
            if (np + [a])
                 .group_by(&:itself)
                 .any? { |k, v| k == k.downcase && v.size > 1 }
              next
            end
            k += 1
            new_ << np
          end
      end
      any = true unless bs.superset?(new_.to_set)
      bs.merge new_
    end

    break unless any
  end

  partials['start'].select { |p| p.last == 'end' }.size
end

def part2
  graph = {}
  $lines.each do |l|
    a, b = l.split('-', 2)
    (graph[a] ||= []) << b
    (graph[b] ||= []) << a
  end
  graph['end'] = []

  partials = {}
  graph.each do |a, bs|
    (partials[a] ||= Set.new).merge((bs - ['start']).map(&method(:Array)))
  end

  graph.size.times do |i|
    k = 0
    any = false
    partials.each do |a, bs|
      new_ = []
      bs.each do |path|
        partials
          .fetch(path.last)
          .each do |n|
            nl = n.last
            next if (i >= 1 && nl == a.downcase) && (i >= 1 && nl != 'end')
            np = path + n
            next if np.size <= 2**i
            dups =
              (np + [a])
                .group_by(&:itself)
                .select { |k, v| k == k.downcase && v.size > 1 }
            next if dups.size > 1
            next if dups.values.any? { |v| v.size > 2 }
            k += 1
            new_ << np
          end
      end
      any = true unless bs.superset?(new_.to_set)
      bs.merge new_
    end

    pp i => k
    break unless any
  end

  puts partials['start']
         .select { |p| p.last == 'end' }
         .map { |a| (['start'] + a).join(',') }
         .sort
         .size
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

  has_loops = ->(a) do
    /([a-zA-Z]+)-(.+?)-\1-(.*?-)?\1-\2-\1-(.*?-)?\1-\2-\1/.match?(a.join('-'))
  end

  v = ->(pt, t, seen) do
    return [] if t.empty? && pt != 'start'
    large = pt == pt.upcase
    w_pt = t.map { |path| path + [pt] }.reject(&has_loops)
    return w_pt if pt == 'end'

    w_pt.delete_if do |path|
      dups =
        path.group_by(&:itself).select { |k, v| k == k.downcase && v.size > 1 }
      !seen.add?(path) || dups.size > 1 || dups.values.any? { |v| v.size > 2 }
    end unless large

    succ = graph[pt]

    succ.flat_map { |s| v[s, w_pt, seen] }
  end

  v['start', [[]], Set.new].sort.map { |i| i.join(',') }.size
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
