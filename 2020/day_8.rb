#!/usr/bin/env ruby

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$input_lines = $input.split("\n")

VM = Struct.new(:accumulator, :rip, :inst, :ran) do
  def run
    loop do
      i, a, = *inst[rip]
      return [:term, accumulator] unless i
      return [:looped, accumulator] unless ran.add?(rip)

      case i
      when 'acc'
        self.accumulator += a
      when 'jmp'
        self.rip += a
        next
      when 'nop'
        nil
      else
        raise "unknown #{inst[rip]} #{i} #{a}"
      end
      self.rip += 1
    end
  end
end

$vm = VM.new(0, 0, $input_lines.map { |l| i, a = l.split(' ', 2); [i, a&.to_i] }, Set.new)

def part1
  $vm.run[1]
end

def part2
  inst = $input_lines.map { |l| i, a = l.split(' ', 2); [i, a&.to_i] }
  inst.count.times do |i|
    ins = inst.dup
    is = inst[i].dup
    if is[0] == 'jmp'
      is[0] = 'nop'
    elsif is[0] == 'nop'
      is[0] = 'jmp'
    end
    ins[i] = is
    vm = VM.new(0, 0, ins, Set.new)
    a, b = vm.run
    return b if a == :term
  end
end

pp part1
pp part2

__END__
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
