#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$tiles = $input.split("\n\n").map { |s| [(s.lines[0].split(' ', 2)[-1])[0..-2].to_i, s.split("\n")[1..-1]] }.to_h

def parse_image(i)
  Matrix[*
    i.each_line.map do |l|
      l.chomp.each_char.map do |c|
        c
      end
    end
  ]
end

def flip_x(m)
  Matrix.columns(m.column_vectors.reverse)
end

def flip_y(m)
  Matrix.rows(m.row_vectors.reverse)
end

def rotate(m)
  Matrix.columns(m.transpose.column_vectors.reverse)
end

def stitch_squares(sqs)
  size = sqs.size.**(0.5).to_i
  Matrix.vstack(*sqs.each_slice(size).map { |r| Matrix.hstack(*r) })
end

def all_rotations(tr)
  [tr, ->(t) { rotate(tr[t]) }, ->(t) { rotate rotate(tr[t]) }, ->(t) { rotate rotate rotate(tr[t]) }]
end

def print_image(i)
  i.row_vectors.map { |v| v.to_a.join }.join("\n")
end

TRANSFORMS = all_rotations(->(t) { t }) + all_rotations(method(:flip_x)) + all_rotations(method(:flip_y)) + all_rotations(->(t) { flip_x flip_y t })
# [
# 	->(before) { before },
# 	->(before) { flip_x(before) },
# 	->(before) { flip_y(before) },
# 	->(before) { rotate(before) },
# 	->(before) { rotate(flip_y(before)) },
# 	->(before) { rotate(flip_x(before)) },
# 	->(before) { rotate(rotate(before)) },
# 	->(before) { rotate(rotate(rotate(before))) },
# ]

# T2 = [
#     {t: [:t, 0], b: [:b, 0], l: [:l, 0], r: [:r, 0]},
#     {t: [:t, 1], b: [:b, 1], l: [:l, 0], r: [:r, 0]},
#     {t: [:b, 0], b: [:t, 0], l: [:l, 1], r: [:r, 1]},
#     {t: [:r, 0], b: [:l, 0], l: [:t, 0], r: [:r, 0]},

#     {t: [:b, 0], b: [:t, 0], l: [:r, 1], r: [:r, 1]},
#     {t: [:r, 1], b: [:t, 0], l: [:r, 1], r: [:r, 1]},
# ]

def part1
  edges = Hash.new { |h, k| h[k] = [] }
  $tiles.each do |n, s|
    edges[s[0].chars] << [n, :t, 0]
    edges[s[-1].chars] << [n, :b, 0]
    edges[s.map { |a| a[0] }] << [n, :l, 0]
    edges[s.map { |a| a[-1] }] << [n, :r, 0]
    edges[s[0].chars.reverse] << [n, :t, 1]
    edges[s[-1].chars.reverse] << [n, :b, 1]
    edges[s.map { |a| a[0] }.reverse] << [n, :l, 1]
    edges[s.map { |a| a[-1] }.reverse] << [n, :r, 1]
  end
  edges.transform_keys!(&:join)
  #   edges.reject! { |_, v| v.size == 1 || (v.map(&:first).uniq.size == 1) }
  #   edges.transform_values!(&:sort)

  edges.select { |_, v| v.map(&:first).uniq.size == 1 }.each_value.map { |v| v.first.first }.group_by(&:itself).transform_values(&:count).select { |_k, v| v == 4 }.each_key.reduce(1, &:*)
end

def part2
  edges = Hash.new { |h, k| h[k] = [] }
  $tiles.each do |n, s|
    edges[s[0].chars] << [n, :t, 0]
    edges[s[-1].chars] << [n, :b, 0]
    edges[s.map { |a| a[0] }] << [n, :l, 0]
    edges[s.map { |a| a[-1] }] << [n, :r, 0]
    edges[s[0].chars.reverse] << [n, :t, 1]
    edges[s[-1].chars.reverse] << [n, :b, 1]
    edges[s.map { |a| a[0] }.reverse] << [n, :l, 1]
    edges[s.map { |a| a[-1] }.reverse] << [n, :r, 1]
  end
  edges.transform_keys!(&:join)

  cvals = edges.select { |_, v| v.map(&:first).uniq.size == 1 }.each_value.map { |v| v.first }.group_by(&:first).select { |_k, v| v.count == 4 }.keys

  evals = edges.select { |_, v| v.map(&:first).uniq.size == 1 }.each_value.map { |v| v.map(&:first).first }
  edges.reject! { |_, v| v.size == 1 || (v.map(&:first).uniq.size == 1) }
  pairs = []
  until edges.all? { |_, v| v.empty? }
    given_pairs = edges.select { |_, v| v.map(&:first).uniq.size == 2 }.values
    pairs.concat given_pairs.dup
    given_pairs = given_pairs.flatten(1)
    edges.transform_values! do |v|
      v.reject { |e| given_pairs.include?(e) }
    end
    edges.reject! { |_, v| v.empty? }
    edges.count { |_, v| !v.empty? }
  end

  tiles = $tiles.transform_values { |v| parse_image(v.join("\n")) }

  dim = tiles.size.**(0.5).to_i

  corners = [[0, 0], [0, dim - 1], [dim - 1, 0], [dim - 1, dim - 1]]

  allperms = tiles.transform_values { |v| TRANSFORMS.map { |t| t[v] } }

  recur = lambda do |tiling, r, c, unseen|
    return tiling if r == dim

    r_ = r
    c_ = c + 1

    if c_ == dim
      r_ += 1
      c_ = 0
    end

    cand = unseen

    if corners.include?([c, r])
      cand &= cvals
    elsif (r == 0) || (r == dim - 1) || (c == 0) || (c == dim - 1)
      cand &= evals
    end

    cand.each do |t_|
      allperms[t_].each do |perm|
        next if r != 0 && perm.row_vectors[0] != tiling[r - 1][c].row_vectors[-1]
        next if c != 0 && perm.column_vectors[0] != tiling[r][c - 1].column_vectors[-1]

        tiling[r][c] = perm
        return tiling if recur.call(tiling, r_, c_, unseen - [t_].to_set)
      end
    end
    nil
  end

  tiling = recur.call(Array.new(dim) { [nil] * dim }, 0, 0, tiles.keys.to_set)
  tiling.map! do |row|
    row.map do |img|
      Matrix.build(img.row_count - 2) { |x, y| img[x + 1, y + 1] }
    end
  end
  monster = <<~EOS
                      #
    #    ##    ##    ###
     #  #  #  #  #  #
  EOS
  monster_pd = monster.count('#')
  monster_rs = monster.each_line.map { |l| Regexp.new(l.chomp.tr(' ', '.')) }

  img = stitch_squares(tiling.flatten(1))
  pd_ct = img.count('#')
  TRANSFORMS.map { |t| print_image t[img] }.uniq.sum do |img|
    monster_count = 0

    lines = img.lines
    lines.each_with_index do |l, ln|
      next if ln == 0

      cn = 0
      loop do
        break unless cn = l.index(monster_rs[1], cn)

        if lines[ln - 1].index(monster_rs[0], cn) == cn && lines[ln + 1].index(monster_rs[2], cn) == cn
          monster_count += 1
        end
        cn += 1
      end
    end

    if monster_count > 0
      pd_ct - monster_pd * monster_count
    else
      0
    end
  end
end

pp part1
pp part2

__END__
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
