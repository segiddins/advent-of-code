#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

DIRS = {
  'e' => 1 + 0i,
  'w' => -1 + 0i,
  'sw' => - 1i,
  'se' => 1 - 1i,
  'nw' => - 1 + 1i,
  'ne' => 1i
}.freeze

def part1
  g = Hash.new { |h, k| h[k] = 0 }
  $lines.each do |l|
    k = l.scan(/e|se|sw|w|nw|ne/).sort.reduce(0 + 0i) do |acc, elem|
      acc + DIRS[elem]
    end
    g[k.rectangular.map { |r| r.round(2) }] += 1
  end
  g.each_value.count { |t| t.odd? }
end

def part2
  g = Hash.new { |h, k| h[k] = 0 }
  $lines.each do |l|
    k = l.scan(/e|se|sw|w|nw|ne/).sort.reduce(0 + 0i) do |acc, elem|
      acc + DIRS[elem]
    end
    g[k] += 1
  end
  100.times do
    g_ = Hash.new { |h, k| h[k] = 0 }
    g.each_key.flat_map { |k| DIRS.each_value.map { |d| k + d } }.uniq.each do |s|
      c = DIRS.count { |_k, d| g[s + d].odd? }
      g_[s] =
        if g[s].odd? && ((c == 0) || (c > 2))
          0
        elsif g[s].even? && c == 2
          1
        else
          g[s]
        end
    end
    g = g_
  end
  g.each_value.count { |t| t.odd? }
end

pp part1
pp part2

__END__
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
