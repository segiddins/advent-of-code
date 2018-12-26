#!/usr/bin/ruby

require 'set'

def fill(pts)
  origin, _ = pts.find { |_, v| v == '+' }
  origins = [origin]
  y_min = pts.each_key.map(&:imaginary).min
  c = 0
  while o = origins.tap(&:uniq!).pop
      bottom = o - 1i
      loop do
        if bottom.imag < y_min || pts[bottom] == '|'
          pts[bottom += 1i] = '|' until bottom == o
          break
        end
        break unless [nil, '.'].include?(pts[bottom])
        bottom -= 1i
      end
      fill_level = bottom + 1i
      next if bottom == o

      left_obstacle = fill_level
      left_obstacle -= 1 until ['#'].include?(pts[left_obstacle-1]) || [nil, '.'].include?(pts[left_obstacle - 1i])

      right_obstacle = fill_level
      right_obstacle += 1 until ['#'].include?(pts[right_obstacle+1]) || [nil, '.'].include?(pts[right_obstacle - 1i])

      if pts[left_obstacle-1] == '#' && pts[right_obstacle + 1] == '#'
        left_obstacle.real.upto(right_obstacle.real) { |x| pts[fill_level.imag * 1i + x] = '~' }
        if fill_level == o
          origins << fill_level + 1i
        else
          origins << o
        end
      else
        left_obstacle.real.upto(right_obstacle.real) { |x| pts[fill_level.imag * 1i + x] = '|' }
        fill_level.imag.upto(o.imag.pred) { |x| pts[fill_level.real + x*1i] = '|' }
        if pts[left_obstacle-1] != '#'
          origins << left_obstacle
        end
        if pts[right_obstacle+1] != '#'
          origins << right_obstacle
        end
      end

#    $c ||= 0
#    if ($c += 1) % 200 == 0
#      pp h = [o, fill_level, left_obstacle, right_obstacle]
#      print_ground(pts, h)
#      puts '*' * 180
#      $stdout.flush
#    end
  end
end

def print_ground(pts, highlights=[])
  spread_minmax = ->(x) { n, x = x.minmax; [n.pred, x.succ] }
  Range.new(*pts.each_key.map(&:imaginary).map(&:abs).minmax).each do |y|
    Range.new(*spread_minmax[pts.each_key.map(&:real)]).each do |x|
      pt = x-y*1i
      if highlights.include?(pt)
        print 'H'
      else
        print pts.fetch(pt, '.')
      end
    end
    puts
  end
end

def parse(s)
  veins = s.each_line.map do |l|
    raise unless l =~ /^(.)=(\d+). (.)=(\d+)\.\.(\d+)$/

    { $1.to_sym => $2.to_i, $3.to_sym => Range.new($4.to_i, $5.to_i) }
  end

  each = ->(x, &b) {
    case x
    when Integer then b[x]
    when Range then x.each(&b)
    else raise
    end
  }

  pts = Hash.new('.')
  pts[500+0i] = '+'
  veins.each do |v|
    each[v[:x]] do |x|
      each[v[:y]] do |y|
        pts[x - y*1i] = '#'
      end
    end
  end
  pts
end

input = <<~EOS
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
EOS

input = File.read(File.expand_path('day_17_input.txt', __dir__))

ground = parse(input)
fill ground

max_y = ground.select { |_, v| v == '#' }.map(&:first).map(&:imaginary).max

pp ground.each.count { |pt, v| %w[~ |].include?(v) && pt.imaginary <= max_y }
pp ground.each_value.count { |v| v == '~' }
