#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")

FourDPoint = Struct.new(:x, :y, :z, :w)

$map = Hash.new('.').tap do |map|
  $input_lines.each_with_index do |row, r|
    row.chars.each_with_index do |a, c|
      map[FourDPoint.new(r, c, 0, 0)] = a
    end
  end
end.freeze

def run(abs_dw:)
  map = $map
  1.upto(6) do |_iter|
    nm = map.dup

    min_x, max_x = map.each_key.map(&:x).minmax
    min_y, max_y = map.each_key.map(&:y).minmax
    min_z, max_z = map.each_key.map(&:z).minmax
    min_w, max_w = map.each_key.map(&:w).minmax

    min_x.pred.upto(max_x.succ) do |x|
      min_y.pred.upto(max_y.succ) do |y|
        min_z.pred.upto(max_z.succ) do |z|
          min_w.pred.upto(max_w.succ) do |w|
            an = 0

            -1.upto(1) do |dx|
              -1.upto(1) do |dy|
                -1.upto(1) do |dz|
                  (-abs_dw).upto(abs_dw) do |dw|
                    next if dx.zero? && dy.zero? && dz.zero? && dw.zero?

                    an += 1 if map[FourDPoint.new(x + dx, y + dy, z + dz, w + dw)] == '#'
                  end
                end
              end
            end

            coord = FourDPoint.new(x, y, z, w)

            if map[coord] == '#'
              nm[coord] = '.' unless (an == 2) || (an == 3)
            else
              nm[coord] = '#' if an == 3
            end
          end
        end
      end
    end

    map = nm
  end

  map.count { |_, v| v == '#' }
end

def part1
  run(abs_dw: 0)
end

def part2
  run(abs_dw: 1)
end

pp part1
pp part2

__END__
.#.
..#
###
