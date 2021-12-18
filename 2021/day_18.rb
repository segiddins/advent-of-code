#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
# $input = DATA.read
$lines = $input.split("\n")

def reduce(sn)
  puts "Reducing #{sn.depth} > #{sn}"
  if sn.depth >= 4 # explode
    (0...sn.index).reverse_each do |idx|
      pair = sn.list[idx]
      next if pair.child?(sn)
      if pair.right.is_a?(Numeric)
        puts "Adding left to right of #{pair}"
        pair.right += sn.left
        break
      elsif pair.left.is_a?(Numeric)
        puts "Adding left to left of #{pair}"
        pair.left += sn.left
        break
      end
    end
    (sn.index.succ...sn.list.size).each do |idx|
      pair = sn.list[idx]
      if pair.left.is_a?(Numeric)
        puts "Adding right to left of #{pair}"
        pair.left += sn.right
        break
      elsif pair.right.is_a?(Numeric)
        puts "Adding right to right of #{pair}"
        pair.right += sn.right
        break
      end
    end
    sn.delete = true
    reduce_from(parse(sn.root.to_s), sn.index).tap { |a| puts "         #{sn.depth} < #{a}" }
  elsif sn.left.is_a?(Numeric) && sn.right.is_a?(Numeric) && sn.left + sn.right >= 10
    # Split
    sn
  else
    nil
  end
end

def reduce_from(root, idx)
  return root if idx < 0

  loop do
    break unless sn = root.list[idx]
    if (sn =  reduce(sn))
      return sn.root
    end
    idx += 1
  end
  root
end

Pair = Struct.new(:left, :right, :depth, :parent, :index, :delete) do
  def root
    return self if depth.zero?
    p = parent
    while p&.parent
      p = p.parent
    end
    p
  end



  def add_left(n)
    return unless parent
    # return if parent.left ==
  end

  def list
    return root.list if depth != 0
    
    l = []
    each { |p| l << p }
    l
  end

  def child?(p)
    each { |c| return true if c == p }
    false
  end

  def each(&b)
    yield self
    if left.is_a?(Pair)
      left.each(&b)
    end
    if right.is_a?(Pair)
      right.each(&b)
    end
    nil
  end

  def to_s
    return right.to_s if left.is_a?(Pair) && left.delete
    return left.to_s if right.is_a?(Pair) && right.delete
    "[#{left},#{right}]"
  end
end

def parse(l)
  l = l.dup
  stack = []
  idx = 0
  loop do
    case l[0]
    when '['
      l.slice!(0, 1)
      tmp = Pair.new
      tmp.depth = stack.size
      tmp.parent = curr = stack.last
      tmp.index = idx
      idx += 1
      stack << tmp
      curr.left.nil? ? (curr.left = tmp) : curr.right = tmp if curr
    when ']'
      l.slice!(0, 1)
      stack.pop unless stack.size == 1
    when ','
      l.slice!(0, 1)
    when nil
      break
    when /\d/
      i = l[/^\d+/]
      (i && i != '') || raise("No int starting #{l.inspect}")
      l.slice!(0, i.length)
      i = i.to_i
      curr = stack.last || raise("Nothing in stack: #{stack}")
      curr.left.nil? ? (curr.left = i) : curr.right = i
    else
      raise "Unhandled: #{l.inspect}"
    end
  end
  raise "Extra: #{l.inspect}" unless l.empty?
  stack.first
end

def r(s, i, is_2p)
  loop do
    pred = s[0, i]
    depth = pred.count('[') - pred.count(']')
    succ = s[(i+1)..-1]

    # pp pred: pred&.join(' '), mid: s[i], succ: succ&.join(' ')

    case s[i]
    when nil
      return is_2p ? s : r(s, 0, true)
    when /\d+/
      left = s[i].to_i
      if s[i+2] =~ /\d+/ && depth > 4
        right = s[i+2].to_i
        # naked pair

          # puts "Exploding [#{s[i]}, #{s[i+2]}] in #{s.join}"
          l = pred.rindex { |e| e =~ /\d+/ }
          pred[l] = (s[l].to_i + left).to_s if l
          r = succ[2..-1]&.index { |e| e =~ /\d+/ }
          succ[r+2] = (succ[r+2].to_i + right).to_s if r
          return r(pred[0..-2] + %w[0] + succ[3..-1], 0, false)
      elsif is_2p and left >= 10
        # puts "Splitting #{left} in #{s.join}"
        half = left / 2.0
        left = half.floor
        right = half.ceil
        return r(pred + %W([ #{left} , #{right} ]) + succ, 0, false)
      end
    end
    i += 1
  end
end

def do_r(s)
  r(s, 0, false)
end

def mag(s)
  s = s.join
  loop do
    return s.to_i if s =~ /^\d+$/
    s.sub!(/\[(\d+),(\d+)\]/) { ($1.to_i * 3 + $2.to_i * 2).to_s }
  end
end

def part1
  # sn = $lines.map do |l|
  #   reduce_from(parse(l), 0).to_s
  # end

  $lines.map do |l|
    s = l.scan(/[\[\],]|\d+/)
  end.reduce do |acc, elem|
    do_r(%w([) + acc + [','] + elem + [']'])
  end.yield_self(&method(:mag))
  
end

def part2
  $lines.map do |l|
    s = l.scan(/[\[\],]|\d+/)
  end.permutation(2).map do |l, r|
    mag do_r(%w([) + l + [','] + r + [']'])
  end.max
end

pp part1
pp part2

__END__
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]