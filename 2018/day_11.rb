#!/usr/bin/env ruby

require 'matrix'

serial_number = 4151

grid = Matrix.build(301, 301) do |x, y|
  next -300 if x == 0 || y == 0
  rack_id = x + 10
  power = rack_id * y
  power += serial_number
  power *= rack_id
  (power % 1000)./(100) - 5
end

def total_power(grid, x, y, size)
  total = 0
#  pp xy: [x,y]
  return if x.zero? || y.zero?
  return if x + size >= grid.column_count
  return if y + size >= grid.row_count
  x.upto(x+size - 1) do |x|
    y.upto(y+size - 1) do |y|
#    pp [x, y]
      return unless v = grid[x, y]
      total += v
    end
  end
  total
end

totals_grid = Matrix.build(301, 301) do |x, y|
  total_power(grid, x, y, 1)
end

#pp grid[122,79]

#idx = totals_grid.index(totals_grid.each.to_a.compact.max)
#pp idx#, totals_grid[*idx]

#puts grid.send(:rows).map {|r| r.map {|i| i.to_s.rjust(2) }.join ' '}

totals = {
  1 => grid,
}
vs = 1.upto(300).map do |size|
#  pp size: size
  prev = totals[size - 1]
  totals[size] ||= Matrix.build(301, 301) do |x, y|
    next unless pr = prev[x,y]
    next unless x + size <= 300
    next unless y + size <= 300
#    pp x:x,y:y
#    added = [[x+size-1, y+size-1]] 
    pr +
      (size.pred.times.sum do |s|
#        added.append([x+size-1, y+s], [x+s, y+size-1])
          grid[x+size-1, y+s] + grid[x+s, y+size-1]
      end) + grid[x+size-1, y+size-1]#.tap { pp added.sort }
  end
#  pp totals[size][20,46]
  idx, v = totals[size].each_with_index.map do |i, x, y|
    [[x,y], i]
  end.select(&:last).max_by(&:last)
  next unless idx
  [idx.append(size).join(?,), v]
end.compact

pp vs[2]

pp vs.max_by(&:last)