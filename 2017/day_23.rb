#!/usr/bin/env ruby

def i_or_sym(x)
  if x =~ /\A-?\d+\z/
    x.to_i
  else
    x.to_sym
  end
end
  
instructions = DATA.readlines.map { |l|l=~/\A(\w+) (.+) (.+)\Z/ and [$1.to_sym, i_or_sym($2), i_or_sym($3)] }.compact

targets = []
prog = "#include <stdio.h>\nint main() {\n#{('a'..'h').map {|l| "  long long #{l} = 0;\n"}.join}\n\n" + "  a = 1;\n\n" +
instructions.+([nil]).each_with_index.map do |(ins, x, y), l|
  case ins
  when nil
    "printf(\"%lld\", h);"
  when :set
    "#{x} = #{y};"
  when :sub
    "#{x} -= #{y};"
  when :mul
    "#{x} *= #{y};"
  when :jnz
    targets << l+y
    "if (#{x}) goto line_#{l+y};"
  end
end.each_with_index.map {|s,l| if targets.include?(l) then "line_#{l}:\n  " + s else '  ' + s end }.join("\n") + "\n}"

#preambles = Hash.new{|h,k| h[k] = [] }
#posts = Hash.new{|h,k| h[k] = [] }
#indent = 1
#prog = "#include <stdio.h>\nint main() {\n#{('a'..'h').map {|l| "  long long #{l} = 0;\n"}.join}\n\n" + "  a = 1;\n\n" +
#instructions.+([nil]).each_with_index.map do |(ins, x, y), l|
##  "  line_#{l}:\n    " + 
#  case ins
#  when nil
#    "printf(\"%lld\", h);"
#  when :set
#    "#{x} = #{y};"
#  when :sub
#    "#{x} -= #{y};"
#  when :mul
#    "#{x} *= #{y};"
#  when :jnz
#    if y > 0
#      posts[l+y-1] << [l, "}"]
#      preambles[l] << [l+y, "if (!#{x}) {"]
#    else
#      preambles[l+y] << [l, "do {"]
#      posts[l] << [l+y, "} while (!#{x});"]
#    end
#    "// target: #{l+y}"
##    "if (#{x}) goto line_#{l+y};"
#  end&.+ " // line #{l}: #{ins} #{x} #{y}"
#end.each_with_index.map do |s,l|
#  x = ''
#  preambles[l].sort_by(&:first).reverse.map(&:last).each do |a|
#    x << "  " * indent
#    x << a << "\n"
#    indent += 1
#  end
#  unless s.nil?
#    x << "  " * indent
#    x << s << "\n"
#  end
#  posts[l].sort_by(&:first).map(&:last).each do |a|
#    indent -= 1
#    x << "  " * indent
#    x << a << "\n"
#  end
#  x
#end.join + "\n}"

puts prog

File.write('day_23.c', prog)
`rm -f day_23.o`
`clang -O3 day_23.c -o day_23.o`; $?.success? || exit($?.exitstatus)
puts `./day_23.o`
`rm day_23.o`
exit

registers = {a:1,b:0,c:0,d:0,e:0,f:0,g:0,h:0}

get = ->(x) { case x when Symbol then registers[x] else x end }

ip = 0
mul_count = 0
loop do
  ins, x, y = instructions[ip]
  y = get[y]
  case ins
  when nil
    break
  when :set
    registers[x] = y
  when :sub
    registers[x] -= y
  when :mul
    registers[x] *= y
#    mul_count += 1
  when :jnz
    if get[x].nonzero?
      ip += y
      next
    end
  end
  ip += 1
end

pp mul_count
pp registers[:h]

__END__
set b 67
set c b
#jnz a 2
#jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23