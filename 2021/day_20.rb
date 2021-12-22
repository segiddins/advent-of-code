#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def enhance(img, algo, default)
  new_img = Hash.new { |h, k| default }
  min_x, max_x = img.each_key.map(&:x).minmax
  min_y, max_y = img.each_key.map(&:y).minmax

  reach = 1
  (min_x - reach).upto(max_x + reach) do |x|
    (min_y - reach).upto(max_y + reach) do |y|
      pt = Point.new(x, y)

      neighbors =
        [-1, 0, 1].flat_map do |dy|
          [-1, 0, 1].map do |dx|
            x_ = pt.x + dx
            y_ = pt.y + dy

            img[Point.new(x_, y_)]
          end
        end

      nv = algo[neighbors]
      next if nv == default
      new_img[pt] = nv
    end
  end

  new_img
end

def part1
  algo =
    $lines
      .first
      .chars
      .each_with_index
      .map do |v, idx|
        [idx.to_s(2).rjust(9, '0').gsub(/./, '0' => '.', '1' => '#').chars, v]
      end
      .to_h

  invert = algo[['.'] * 9] == '#'

  image =
    $lines[2..-1]
      .each_with_index
      .flat_map do |l, y|
        l.chars.each_with_index.map { |p, x| [Point.new(x, y), p] }
      end
      .reject { |k, v| v == '.' }
      .to_h
  image.default_proc = ->(h, k) { '.' }

  default = invert ? '#' : '.'
  2.times do
    image = enhance(image, algo, default)
    default = { '.' => '#', '#' => '.' }[default] if invert
  end
  image.each_value.count { |v| v == '#' }
end

def part2
  algo =
    $lines
      .first
      .chars
      .each_with_index
      .map do |v, idx|
        [idx.to_s(2).rjust(9, '0').gsub(/./, '0' => '.', '1' => '#').chars, v]
      end
      .to_h
  invert = algo[['.'] * 9] == '#'

  image =
    $lines[2..-1]
      .each_with_index
      .flat_map do |l, y|
        l.chars.each_with_index.map { |p, x| [Point.new(x, y), p] }
      end
      .reject { |k, v| v == '.' }
      .to_h
  image.default_proc = ->(h, k) { '.' }

  default = invert ? '#' : '.'
  50.times do
    image = enhance(image, algo, default)
    default = { '.' => '#', '#' => '.' }[default] if invert
  end
  image.each_value.count { |v| v == '#' }
end

pp part1
pp part2

__END__
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
