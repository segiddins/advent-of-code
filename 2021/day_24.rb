#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def parse_instructions(lines)
  lines.map do |l|
    l
      .split(' ', 3)
      .map { |part| part.match?(/^-?\d+$/) ? part.to_i : part.to_sym }
  end
end

$instructions = parse_instructions($lines)

def to_c
  puts '#include <stdio.h>'
  puts '#include <stdlib.h>'
  puts
  puts 'int main(int argc, char** argv) {'
  puts "\tint idx = 0;"
  puts "\tint w = 0, x = 0, y = 0, z = 0;"
  $instructions.each do |inst, a, b|
    print "\t#{a} = "
    if inst == :inp
      puts "argv[1][idx++] - '\\0';"
      next
    end

    print "#{a} "

    print case inst
          when :add
            '+'
          when :mul
            '*'
          when :div
            '/'
          when :mod
            '%'
          when :eql
            '=='
          else
            raise
          end
    puts " #{b};"
  end
  puts "\treturn z == 0 ? 0 : 1;"
  puts '}'
end

# to_c
# exit

ALU =
  Struct.new(:w, :x, :y, :z, :serial) do
    def run(inst, a, b)
      b = self[b] if b.is_a?(Symbol)

      self[a] =
        case inst
        when :inp
          # puts z
          serial.shift
        when :add
          self[a] + b
        when :mul
          self[a] * b
        when :div
          self[a] / b
        when :mod
          self[a] % b
        when :eql
          self[a] == b ? 1 : 0
        else
          raise
        end
    end

    def run_many(insts)
      insts.each { |inst, a, b| run(inst, a, b) }
      z
    end
  end

def part1
  sections =
    $input
      .split(/inp w/)
      .map do |s|
        next if s.empty?

        parse_instructions("inp w#{s}".split("\n"))
      end
      .compact

  # 1.upto(9) do |d|
  #   sections[1]
  #          .each_with_object(
  #            ALU.new(0, 0, 0, 15, [d])
  #          ) { |(i, a, b), alu| alu.run(i, a, b) }
  #          .z.tap { |z| pp d => z.to_s(26)}
  # end

  sections.map do |sect|
    { div_z: sect.dig(4, 2), add_y: sect.dig(-3, 2), add_x: sect.dig(5, 2) }
  end

  # push +6
  # push +12
  #   push +8
  #   pop if top of stack -11 == digit
  # push +7
  # push +12
  #   push +2
  #   pop if top of stack -7 == digit
  #   push +4
  #   pop if top of stack -6 == digit
  # pop if top of stack -10 == digit
  # pop if top of stack -15 == digit
  # pop if top of stack -9 == digit
  # pop if top of stack == digit

  digits = [3, 6, 9, 6, 9, 7, 7, 2, 9, 7, 9, 1, 9, 9]

  # 36969772979199 too low {0=>3, 1=>6, 2=>9, 3=>6, 4=>9, 5=>7, 6=>7, 7=>2, 8=>9, 9=>7, 10=>9, 11=>1, 12=>9, 13=>9}
  # 36969994977199 wrong   {0=>3, 1=>6, 2=>9, 3=>6, 4=>9, 5=>9, 6=>9, 7=>4, 8=>9, 9=>7, 10=>7, 11=>1, 12=>9, 13=>9}
  # 36969794979199

  digits = Array.new(14) { 0 }

  # [0] + 3 == [-1] => [-1] - [0] = 6
  digits[-1] = 9
  digits[0] = 3

  # [1] + 12 == [-2] + 9 => [-2] - [1] = 3
  digits[-2] = 9
  digits[1] = 6

  # [2] + 8 == [3] + 11 => [3] - [2] = -3
  digits[3] = 6
  digits[2] = 9

  # [4] + 7 == [-3] + 15 => [-3] - [4] = -8
  digits[-3] = 1
  digits[4] = 9

  # [5] + 12 == [-4] + 10 => [-4] - [5] = 2
  digits[-4] = 9
  digits[5] = 7

  # [6] + 2 == [7] + 7 => [7] - [6] = -5
  digits[7] = 4
  digits[6] = 9

  # [8] + 4 == [-5] + 6 => [-5] - [8] = -2
  digits[-5] = 7
  digits[8] = 9

  ALU.new(0, 0, 0, 0, digits.dup).run_many(sections[0, digits.size].flatten(1))

  # .tap { |z| pp z: z.to_s(26)}
  digits.each_with_index.to_a.map(&:reverse).to_h
  digits.join.to_i
end

def part2
  sections =
    $input
      .split(/inp w/)
      .map do |s|
        next if s.empty?

        parse_instructions("inp w#{s}".split("\n"))
      end
      .compact

  digits = Array.new(14) { 0 }

  # [0] + 3 == [-1] => [-1] - [0] = 6
  digits[-1] = 7
  digits[0] = 1

  # [1] + 12 == [-2] + 9 => [-2] - [1] = 3
  digits[-2] = 4
  digits[1] = 1

  # [2] + 8 == [3] + 11 => [3] - [2] = -3
  digits[3] = 1
  digits[2] = 4

  # [4] + 7 == [-3] + 15 => [-3] - [4] = -8
  digits[-3] = 1
  digits[4] = 9

  # [5] + 12 == [-4] + 10 => [-4] - [5] = 2
  digits[-4] = 3
  digits[5] = 1

  # [6] + 2 == [7] + 7 => [7] - [6] = -5
  digits[7] = 1
  digits[6] = 6

  # [8] + 4 == [-5] + 6 => [-5] - [8] = -2
  digits[-5] = 1
  digits[8] = 3

  ALU.new(0, 0, 0, 0, digits.dup).run_many(sections[0, digits.size].flatten(1))

  # .tap { |z| pp z: z.to_s(26)}
  digits.each_with_index.to_a.map(&:reverse).to_h
  digits.join.to_i
end

pp part1
pp part2

__END__

