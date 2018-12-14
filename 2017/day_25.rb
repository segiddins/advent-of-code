#!/usr/bin/env ruby

class Node
  attr_reader :previous, :next
  attr_accessor :value
  
  def initialize(previous: nil, n: nil)
    @value = 0
    @next = n
    @previous = previous
  end
  
  def next
    @next ||= Node.new(previous: self)
  end
  
  def previous
    @previous ||= Node.new(n: self)
  end
  
  def to_a
    a = [value]
    current = self
    while (current = current.instance_variable_get(:@previous))
      a.unshift(current.value)
    end
    current = self
    while (current = current.instance_variable_get(:@next))
      a << current.value
    end
    a
  end
end

prog = DATA.read

state = prog =~ /Begin in state (.+)\./ && $1
checksum = prog =~ /Perform a diagnostic checksum after (\d+) steps\./ && $1.to_i

states = {}
s = nil
a = nil
prog.each_line do |l|
  case l
  when /In state (.+):/
    s = $1
    states[s] = {}
  when /If the current value is (\d+):/
    a = states[s][$1.to_i] = []
  when /Write the value (\d+)\./
    m = $1.to_i
    a << ->(vm){ vm.node.value = m }
  when /Move one slot to the right\./
    a << ->(vm){ vm.node = vm.node.next }
  when /Move one slot to the left\./
    a << ->(vm){ vm.node = vm.node.previous }
  when /Continue with state (.+)\./
    m = $1
    a << ->(vm){ vm.state = m }
  end
end

VM = Struct.new(:node, :state) do
  def checksum
    node.to_a.count(1)
  end
end

vm = VM.new(Node.new, state)
checksum.times do
  states[vm.state][vm.node.value].each { |l| l[vm] }
end

p vm.checksum

__END__
    Begin in state A.
    Perform a diagnostic checksum after 12261543 steps.

    In state A:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state B.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state C.

    In state B:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state C.

    In state C:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state D.

    In state D:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state E.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state C.

    In state E:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state F.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.

    In state F:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state E.