#!/usr/bin/env ruby

scoreboard = [3, 7]

elf1_idx = 0
elf2_idx = 1

def print_scoreboard(scoreboard, e1, e2)
  scoreboard.each_with_index do |s, i|
    print(i == e1 ? '(' : '')
    print(i == e2 ? '[': '')
    print s
    print(i == e1 ? ')': '')
    print(i == e2 ? ']': '')
  end
  puts
end

20403320.times do
  # print_scoreboard(scoreboard, elf1_idx, elf2_idx)
  scoreboard.concat (scoreboard[elf1_idx] + scoreboard[elf2_idx]).digits.reverse
  elf1_idx = (elf1_idx + 1 + scoreboard[elf1_idx]) % scoreboard.size
  elf2_idx = (elf2_idx + 1 + scoreboard[elf2_idx]) % scoreboard.size
end

puts(scoreboard[909441, 10].join)
puts(scoreboard.join =~ /909441/)
