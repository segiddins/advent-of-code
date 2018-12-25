require 'set'

VM = Struct.new(:registers) do
  alias r registers

  METHODS = []
  def self.method_added(m)
    METHODS << m
  end

  def addr(a, b, c); r[c] = r[a] + r[b]; end
  def addi(a, b, c); r[c] = r[a] + b; end

  def mulr(a, b, c); r[c] = r[a] * r[b]; end
  def muli(a, b, c); r[c] = r[a] * b; end

  def banr(a, b, c); r[c] = r[a] & r[b]; end
  def bani(a, b, c); r[c] = r[a] & b; end

  def borr(a, b, c); r[c] = r[a] | r[b]; end
  def bori(a, b, c); r[c] = r[a] | b; end

  def setr(a, b, c); r[c] = r[a]; end
  def seti(a, b, c); r[c] = a; end
  
  def gtir(a, b, c); r[c] = a > r[b] ? 1 : 0; end
  def gtri(a, b, c); r[c] = r[a] > b ? 1 : 0; end
  def gtrr(a, b, c); r[c] = r[a] > r[b] ? 1 : 0; end
  
  def eqir(a, b, c); r[c] = a == r[b] ? 1 : 0; end
  def eqri(a, b, c); r[c] = r[a] == b ? 1 : 0; end
  def eqrr(a, b, c); r[c] = r[a] == r[b] ? 1 : 0; end

  METHODS.freeze

  def self.matching_methods(before, args, after)
    METHODS.select do |method|
      vm = VM.new(before.dup)
      vm.send(method, *args)
      vm.registers == after
    end
  end
end

def parse(s)
  m = s.scan(/^Before: (.+)\n(.+)\nAfter: (.+)$/)
  a = m.map do |(b, i, a)|
    [eval(b), i.split(' ').map(&:to_i), eval(a)]
  end
  b = s.split("\n\n\n\n").last.split("\n").map { |l| l.split(' ').map(&:to_i) }
  [a, b]
end
input = "Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]"
input = File.read(File.expand_path('day_16_input.txt', __dir__))

test_cases, test_program = parse(input)
options = 0.upto(15).map {|o| [o, METHODS.to_set] }.to_h
pp(test_cases.count do |b, i, a|
  opcode = i.shift
  matches = VM.matching_methods(b, i, a)
  options[opcode] &= matches
  matches.size >= 3
end)

while sa = options.select {|_,v| v.size == 1 }.map(&:last).reduce(&:union) and sa.size != options.size
  options.each_value { |v| v.subtract(sa) if v.size > 1 }
end

opcodes = options.map {|o, s| [o, s.first] }.to_h

test_vm = VM.new([0,0,0,0])
test_program.each do |o, *a|
  test_vm.send(opcodes[o], *a)
end
pp test_vm.registers[0]