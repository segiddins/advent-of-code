#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$rules, $messages = $input.split("\n\n").map { |l| l.split("\n") }
$rules = $rules.map do |l|
  l =~ /^(\d+): (?:(?:"(.+)")|(.+))/
  [Regexp.last_match(1).to_i,
   Regexp.last_match(2) || Regexp.last_match(3).split(' | ').map { |s| s.split(' ').map(&:to_i) }]
end .to_h

def m(r, s)
  a = $rules[r]

  case a
  when String
    s[0] == a ? [s[1..-1]] : []
  else
    a.flat_map do |sub|
      sub.reduce([s]) do |acc, elem|
        acc.flat_map { |b| m(elem, b) }
      end
    end
  end
end

def part1
  $messages.select { |s| m(0, s) == [''] }.count
end

def part2
  $rules[8] = [[42], [42, 8]]
  $rules[11] = [[42, 31], [42, 11, 31]]

  $messages.select { |s|  m(0, s).include?('') }.count
end

pp part1
pp part2

__END__
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
