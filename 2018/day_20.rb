require 'strscan'

def print_grid(grid)
  Range.new(*grid.each_key.map(&:imag).minmax).reverse_each do |y|
    Range.new(*grid.each_key.map(&:real).minmax).each do |x|
      print grid[x+y*1i]
    end
    puts
  end
end

def dir_for(c)
  case c
  when 'N' then 1i
  when 'S' then -1i
  when 'E' then 1+0i
  when 'W' then -1+0i
  else raise
  end
end

def fill_route(grid, pos, s)
  s.each_char do |c|
    dir = dir_for(c)
    pos += dir
    grid[pos] = dir.real? ? '|' : '-'
    fill_wall(grid, pos)
    pos += dir
    grid[pos] = '.'
    fill_wall(grid, pos)
  end
  pos
end

def fill_wall(grid, pos)
  [-1,0,1].each do |dy|
    [-1, 0, 1].each do |dx|
      grid[pos + dx + dy*1i] ||= '#'
    end
  end
end

def create_grid(regexp)
  pos = 0i
  grid = { pos => 'X' }
  fill_wall(grid, pos)

  s = StringScanner.new(regexp)
  s.skip(/\^/)

  level = 0
  stack = [[]]
  until s.match?(/\$/)
    pos = fill_route(grid, pos, s.scan(/[NESW]+/) || '') if level == 0
    if s.scan(/\(/)
      level += 1

      stack[level].append s.scan_until(/\(|\||\)/)
    end
  end

  grid
end

# print_grid create_grid('^NN$')

class Part
  def initialize(literal:)
    @literal = literal
  end
  def matching_strings
    @matching_strings ||= [@literal]
  end

  def to_regexp_s
    @literal
  end
end

class OrPart
  attr_reader :parts
  def initialize(parts:)
    @parts = parts
  end

  def matching_strings
    @matching_strings ||= parts.flat_map(&:matching_strings).uniq
  end

  def to_regexp_s
    "(#{parts.map(&:to_regexp_s).join('|')})"
  end
end

class AndPart
  attr_reader :parts
  def initialize(parts:)
    @parts = parts
  end

  def matching_strings
    return [''] if parts.empty?
    return parts.flat_map(&:matching_strings) if parts.size == 1
    @matching_strings ||= parts.each_with_object(['']) do |part, matches|
      matches.map! do |match|
        part.matching_strings.map do |rhs|
          match + rhs
        end
      end.flatten!
    end.uniq
  end

  def to_regexp_s
    parts.map(&:to_regexp_s).join
  end
end

def parse(regexp)
  scanner = StringScanner.new(regexp)
  scanner.skip(/\^/)
  part = AndPart.new(parts: [])
  stack = [part]

  until scanner.skip(/\$/)
    if scanner.skip(/\(/)
      part = OrPart.new(parts: [AndPart.new(parts: [])])
      stack.last.parts << part
      stack << part << part.parts.last
    elsif scanner.skip(/\)/)
      stack.pop
      stack.pop
      break if stack.empty?
    elsif scanner.skip(/\|/)
      stack.pop
      part = AndPart.new(parts: [])
      stack.last.parts << part
      stack << part
    elsif s = scanner.scan(/[NEWS]+/)
      stack.last.parts << Part.new(literal: s)
    else
      raise scanner.inspect
    end
  end

  stack.first
end

def grid_from_part(part)
  pos = 0i
  grid = { pos => 'X' }
  fill_wall(grid, pos)

  part.matching_strings.each do |s|
    fill_route(grid, pos, s)
  end

  grid
end

def flatten_part!(part)
  case part
  when AndPart, OrPart
    if part.parts.size < 2
      return part.parts.first
    else
      part.parts.map! { |p| flatten_part!(p) }.compact!
    end
  end
  part
end

input = '^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$'
input = File.read(File.expand_path('day_20_input.txt', __dir__))
part = parse(input)
part = flatten_part!(part)
# print_grid(grid_from_part(part))

require 'set'
class PriorityQueue
  def initialize
    @h = Hash.new {|h,k| h[k] = [] }
  end
  def <<(e, p)
    @h[p] << e
  end
  def pop
    min_p = @h.each_key.min
    a = @h[min_p]
    a.pop.tap { @h.delete(min_p) if a.empty? }
  end
end
def distance(grid, start, goal, came_from = { start => nil }, cost_so_far = { start => 0 })
  to_visit = PriorityQueue.new.tap {|q| q.<<(start, 0) }

  while current = to_visit.pop
    break if current == goal
    adj = %w[N W S E].map {|c| [c, current + dir_for(c)] }.select {|_, pos| grid[pos] != '#' }.map {|c, pos| pos + dir_for(c) }

    adj.each do |n|
      cost = cost_so_far[current] + 1
      if !came_from.key?(n) || cost < cost_so_far[n]
        cost_so_far[n] = cost
        to_visit.<<(n, cost + 1)
        came_from[n] = current
      end
    end
  end

  d = 0
  d += 1 while came_from[goal] && goal = came_from[goal]

  return unless start == goal
  d
end

grid = grid_from_part(part)

ge_1k_doors = 0

p(grid.map do |pos, c|
  next unless c == '.'

  start = 0+0i
  came_from = { start => nil }
  cost_so_far = { start => 0 }
  distance(grid, start, pos, came_from, cost_so_far).tap { |d| ge_1k_doors += 1 if d >= 1_000 }
end.compact.max)

p ge_1k_doors