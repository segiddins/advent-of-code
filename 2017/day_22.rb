#!/usr/bin/env ruby

require 'set'
require 'matrix'

State = Struct.new(:state) do
  def self.clean
    @clean ||= new(:clean)
  end
  def self.weakened
    @weakened ||= new(:weakened)
  end
  def self.infected
    @infected ||= new(:infected)
  end
  def self.flagged
    @flagegd ||= new(:flagged)
  end
  def dir_rot
    @dir_rot ||= 
      case state
      when :clean then Matrix[[0, 1], [-1, 0]]
      when :weakened then Matrix[[1, 0], [0, 1]]
      when :infected then Matrix[[0, -1], [1, 0]]
      when :flagged then Matrix[[-1, 0], [0, -1]]
      end
  end
  
  def next
    case state
    when :clean then State.weakened
    when :weakened then State.infected
    when :infected then State.flagged
    when :flagged then State.clean
    end
  end
  
  def char
    case state
    when :clean then '.'
    when :weakened then 'W'
    when :infected then '#'
    when :flagged then 'F'
    end 
  end
end

class VM
  def self.from_string(str)
    pts = {}
    str.each_line.each_with_index do |l, y|
      l.chomp.each_char.each_with_index do |c, x|
        pts[[x, y]] = State.infected if c == '#'
      end
    end
    max_x = str.scan(/.+/).map(&:size).max
    max_y = str.scan(/\n/).size
    new(pts: pts, carrier: [max_x/2, max_y/2])
  end

  def initialize(pts:, carrier:)
    @pts = pts
    @carrier = carrier
    @dir = Matrix[[0,1]]
  end
  
  def display
    minx, maxx = @pts.each_key.map(&:first).minmax
    miny, maxy = @pts.each_key.map(&:last).minmax
    (miny.pred..maxy.succ).each do |y|
      (minx.pred..maxx.succ).each do |x|
        carrier = @carrier == [x,y]
        print ' ' unless x == minx.pred || carrier
        print '[' if carrier
        char = @pts[[x,y]]&.char || '.'
        print char
        print ']' if carrier
        print ' ' unless carrier
      end
      puts
    end
  end
  
  def advance
    x,y = @carrier
    state = @pts.delete(@carrier) || State.clean
    @dir = @dir * state.dir_rot
    n = state.next
    if n.state != :clean
      @pts[@carrier] = n
    end
    vel_x, vel_y = @dir.to_a.first
    @carrier = [x + vel_x, y - vel_y]
    n.state == :infected
  end
end

vm = VM.from_string("..#\n#..\n...\n")
string = DATA.read
vm = VM.from_string(string)

p(1.upto(10_000_000).sum do |x|
#  p x if x % 10_000 == 0
#  vm.display
#  puts '***' * 10
  vm.advance ? 1 : 0
end)

#vm.display

__END__
..######.###...######...#
.##..##.#....#..##.#....#
.##.#....###..##.###.#.#.
#.#.###.#####.###.##.##.#
.###.#.#.###.####..##.###
..####.##..#.#.#####...##
....##.###..#.#..#...####
.#.##.##.#..##...##.###..
.######..#..#.#####....##
###.##.###.########...###
.#.#.#..#.##.#..###...#..
.#.##.#.####.#.#.....###.
##..###.###..##...#.##.##
##.#.##..#...##...#...###
##..#..###.#..##.#.#.#.#.
.##.#####..##....#.#.#..#
..#.######.##...#..#.##..
#.##...#.#....###.#.##.#.
.#..#.#.#..#.####..#.####
.##...##....##..#.#.###..
..##.#.#.##..##.#.#....#.
###.###.######.#.########
..#.####.#.#.##..####...#
#.##..#.#.####...#..#..##
###.###.#..##..#.###....#