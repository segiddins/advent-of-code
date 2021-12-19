#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def part1
  $lines
    .flat_map { |l| l.split(' | ', 2).last.split(' ') }
    .count { |w| [2, 3, 4, 7].include?(w.size) }
end

def part2
  $lines
    .map do |l|
      l, r = l.split(' | ', 2)
      [l.split(' '), r.split(' ')].map { |a| a.map { |w| w.chars.sort.join } }
    end
    .map do |l, r|
      mapping = Hash.new { |h, k| h[k] = Set.new }

      (l + r).each do |w|
        case w.size
        when 2
          mapping[1] << w
        when 3
          mapping[7] << w
        when 4
          mapping[4] << w
        when 7
          mapping[8] << w
        when 5
          [2, 3, 5].each { |n| mapping[n] << w }
        when 6
          [0, 6, 9].each { |n| mapping[n] << w }
        end
      end

      one = mapping[1].first.chars
      mapping.each do |k, v|
        next if k == 1

        if [2, 5, 6].include?(k)
          v.select! { |w| (one - w.chars).size == 1 }
        else
          v.select! { |w| (one - w.chars).empty? }
        end
      end

      cap_a = (mapping[7].first.chars - mapping[1].first.chars).first
      mapping.each do |k, v|
        if [0, 2, 3, 5, 6, 7, 8, 9].include?(k)
          v.select! { |w| w.include?(cap_a) }
        else
          v.reject! { |w| w.include?(cap_a) }
        end
      end

      seven = mapping[7].first.chars
      mapping.each do |k, v|
        next if k == 7

        if [0, 3, 8, 9].include?(k)
          v.select! { |w| (seven - w.chars).empty? }
        elsif [2, 4, 5, 6].include?(k)
          v.select! { |w| (seven - w.chars).size == 1 }
        end
      end

      # cap_e = (?a..?g).to_a.-(mapping[9].)
      missing = ->(w) { ('a'..'g').to_a.-(w.chars) }
      mapping[5].reject! do |w|
        (mapping[6].to_a.only.chars - w.chars).size != 1
      end

      cap_eg = mapping[8].first.chars - (mapping[4].first.chars + [cap_a])
      mapping.each do |k, v|
        if [0, 2, 6, 8].include?(k)
          v.select! { |w| (cap_eg - w.chars).empty? }
        elsif [3, 5, 9].include?(k)
          v.select! { |w| (cap_eg - w.chars).size == 1 }
        else
          v.select! { |w| (cap_eg - w.chars).size == 2 }
        end
      end

      cap_bd = mapping[4].first.chars - mapping[1].first.chars
      mapping.each do |k, v|
        if [4, 5, 6, 8, 9].include?(k)
          v.select! { |w| (cap_bd - w.chars).empty? }
        elsif [0, 2, 3].include?(k)
          v.select! { |w| (cap_bd - w.chars).size == 1 }
        else
          v.select! { |w| (cap_bd - w.chars).size == 2 }
        end
      end

      cap_d = mapping[8].to_a.only.chars - mapping[0].to_a.only.chars
      cap_b = cap_bd - cap_d
      cap_e = mapping[8].to_a.only.chars - mapping[9].to_a.only.chars
      cap_g = cap_eg - cap_e
      cap_c = mapping[8].to_a.only.chars - mapping[6].to_a.only.chars

      mapping.each do |k, v|
        if [0, 2, 6, 8].include?(k)
          v.select! { |w| (cap_e - w.chars).empty? }
        else
          v.select! { |w| (cap_e - w.chars).size == 1 }
        end

        if [0, 4, 5, 6, 8, 9].include?(k)
          v.select! { |w| (cap_b - w.chars).size == 0 }
        else
          v.select! { |w| (cap_b - w.chars).size == 1 }
        end

        if [0, 2, 3, 5, 6, 8, 9].include?(k)
          v.select! { |w| (cap_g - w.chars).size == 0 }
        else
          v.select! { |w| (cap_g - w.chars).size == 1 }
        end

        if [0, 1, 2, 3, 4, 7, 8, 9].include?(k)
          v.select! { |w| (cap_c - w.chars).size == 0 }
        else
          v.select! { |w| (cap_c - w.chars).size == 1 }
        end
      end

      rm = mapping.each_with_object({}) { |(k, v), a| a[v.to_a.only] = k }

      r.map { |w| rm[w] }.join.to_i
    end
    .sum
end

pp part1
pp part2

__END__
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
