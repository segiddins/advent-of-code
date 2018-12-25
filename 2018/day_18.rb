require 'matrix'

size = 10

def parse(s)
  l = s.lines.size
  s = s.gsub("\n", '')
  Matrix.build(l, l) do |y, x|
    s[x + l * y]
  end
end

def adj(m, x, y)
  [-1, 0, 1].flat_map do |dx|
    [-1, 0, 1].map do |dy|
      next if dy == 0 and dx == 0

      x_ = x + dx
      y_ = y + dy
      next unless x_ >= 0 && y_ >= 0
      next unless x_ < m.row_size and y_ < m.column_size
      m[y_, x_]
    end
  end.compact
end

def tick(m)
  Matrix.build(m.column_size, m.row_size) do |y, x|
    case m[y, x]
    when '.' # open
      adj(m, x, y).count('|') >= 3 ? '|' : '.'
    when '|' # trees
      adj(m, x, y).count('#') >= 3 ? '#' : '|'
    when '#' # lumberyard
      adj(m, x, y).count('|') > 0 && adj(m, x, y).count('#') > 0 ? '#' : '.'
    end
  end
end

def rv(m)
  c = m.to_a.flatten.group_by(&:itself)
  c['#'].size * c['|'].size
end

input = <<-EOS
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
EOS
input = File.read(File.expand_path('day_18_input.txt', __dir__))

a = parse(input)
10.times do |t|
  a = tick(a)
end
pp rv(a)

h = {}
a = parse(input)
end_t = 500_000.times do |t|
  break t if h.key?(a)
  h[a] = [t, rv(a)]
  a = tick(a)
end

cycle_start = h[a].first
cycle_length = end_t - cycle_start
t = ((1_000_000_000 - cycle_start) % cycle_length) + cycle_start
pp h.values.find{|a,_| t == a }.last
