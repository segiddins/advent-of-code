#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
$input = DATA.read
$input_lines = $input.split("\n")

def run(abs_dw:)

end

def part1
  map = Hash.new { |h, k| h[k] = '.' }
  $input_lines.each_with_index do |row, r|
    row.chars.each_with_index do |a, c|
      map[[r, c, 0]] = a
    end
  end

  1.upto(6) do |_iter|
    nm = map.dup

    min_x, max_x = map.map { |k, _v| k[0] }.minmax
    min_y, max_y = map.map { |k, _v| k[1] }.minmax
    min_z, max_z = map.map { |k, _v| k[2] }.minmax

    min_x.pred.upto(max_x.succ) do |x|
      min_y.pred.upto(max_y.succ) do |y|
        min_z.pred.upto(max_z.succ) do |z|
          an = 0

          -1.upto(1) do |dx|
            -1.upto(1) do |dy|
              -1.upto(1) do |dz|
                next if dx.zero? && dy.zero? && dz.zero?

                x_ = x + dx
                y_ = y + dy
                z_ = z + dz

                an += 1 if map[[x_, y_, z_]] == '#'
              end
            end
          end

          if map[[x, y, z]] == '#'
            nm[[x, y, z]] = '.' unless (an == 2) || (an == 3)
          else
            nm[[x, y, z]] = '#' if an == 3
          end
        end
      end
    end

    map = nm
  end

  map.count { |_, v| v == '#' }
end

def part2
  map = Hash.new { |h, k| h[k] = '.' }
  $input_lines.each_with_index do |row, r|
    row.chars.each_with_index do |a, c|
      map[[r, c, 0, 0]] = a
    end
  end

  1.upto(6) do |_iter|
    nm = map.dup

    min_x, max_x = map.map { |k, _v| k[0] }.minmax
    min_y, max_y = map.map { |k, _v| k[1] }.minmax
    min_z, max_z = map.map { |k, _v| k[2] }.minmax
    min_w, max_w = map.map { |k, _v| k[3] }.minmax

    min_x.pred.upto(max_x.succ) do |x|
      min_y.pred.upto(max_y.succ) do |y|
        min_z.pred.upto(max_z.succ) do |z|
          min_w.pred.upto(max_w.succ) do |w|
            an = 0

            -1.upto(1) do |dx|
              -1.upto(1) do |dy|
                -1.upto(1) do |dz|
                  -1.upto(1) do |dw|
                    next if dx.zero? && dy.zero? && dz.zero? && dw.zero?

                    x_ = x + dx
                    y_ = y + dy
                    z_ = z + dz
                    w_ = w + dw

                    an += 1 if map[[x_, y_, z_, w_]] == '#'
                  end
                end
              end
            end

            if map[[x, y, z, w]] == '#'
              nm[[x, y, z, w]] = '.' unless (an == 2) || (an == 3)
            else
              nm[[x, y, z, w]] = '#' if an == 3
            end
          end
        end
      end
    end

    map = nm
  end

  map.count { |_, v| v == '#' }
end

pp part1
pp part2

__END__
.#.
..#
###
