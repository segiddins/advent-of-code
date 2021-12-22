#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def mod_min_1(x, modulus)
  x %= modulus
  x.zero? ? modulus : x
end

def part1
  pos = $lines.map { |l| l.split(' ').last.to_i }
  pts = [0, 0]

  die = 0
  roll_count = 0

  loop do
    2.times do |x|
      3.times do
        roll_count += 1
        die = mod_min_1(die + 1, 100)
        pos[x] = mod_min_1(pos[x] + die, 10)
      end
      pts[x] += pos[x]

      # puts "Player #{x + 1} rolls #{rolls.join(',')} moves to space #{pos[x]} for a total score of #{pts[x]}"
      return pts[1 - x] * roll_count if pts[x] >= 1_000
    end
  end
end

Universe =
  Struct.new(:rc, :s1, :s2, :p1, :p2) do
    def roll
      [1, 2, 3].map do |r|
        nu = dup
        nu.rc += 1
        rit = rc % 6
        if rit < 3
          nu.p1 = mod_min_1(p1 + r, 10)
          s1 += nu.p1 if rit == 2
        else
          nu.p2 = mod_min_1(p2 + r, 10)
          s2 += nu.p2 if rit == 5
        end
        nu
      end
    end

    def winner
      if s1 > s2 && s1 >= 21
        1
      elsif s2 >= 21
        2
      end
    end
  end

def part2
  universe = Universe.new(0, 0, 0, *($lines.map { |l| l.split(' ').last.to_i }))

  # universe.roll

  freqs =
    [1, 2, 3].*(3)
      .combination(3)
      .group_by(&:sum)
      .transform_values(&:uniq)
      .transform_values(&:count)
  freqs.each_value.sum.to_r.tap do |s|
    freqs.transform_values! { |f| (27 * f / s).to_i }
  end

  # each set of 3 rolls gives us 27 different worlds, with frequencies
  # 3=>1/27
  # 4=>3/27
  # 5=>6/27
  # 6=>7/27
  # 7=>6/27
  # 8=>3/27
  # 9=>1/27

  worlds = Hash.new { |h, k| h[k] = 0 }
  worlds[universe] = 1

  loop do
    break if worlds.each_key.all?(&:winner)

    2.times do |x|
      new_worlds = Hash.new { |h, k| h[k] = 0 }
      worlds.each do |world, count|
        next new_worlds[world] = count if world.winner

        if x == 0
          freqs.each do |roll, freq|
            new_p = mod_min_1(world.p1 + roll, 10)
            new_worlds[
              Universe.new(
                world.rc + 3,
                world.s1 + new_p,
                world.s2,
                new_p,
                world.p2,
              )
            ] +=
              count * freq
          end
        else
          freqs.each do |roll, freq|
            new_p = mod_min_1(world.p2 + roll, 10)
            new_worlds[
              Universe.new(
                world.rc + 3,
                world.s1,
                world.s2 + new_p,
                world.p1,
                new_p,
              )
            ] +=
              count * freq
          end
        end
      end

      worlds = new_worlds
    end
  end

  worlds
    .group_by { |k, v| k.winner }
    .transform_values { |a| a.sum(&:last) }
    .max_by(&:last)
    .last
end

pp part1
pp part2

__END__
Player 1 starting position: 4
Player 2 starting position: 8
