#!/usr/bin/env ruby
Square = Struct.new(:pos, :num, :value) do
  def to_s
    "#{pos}: #{num}"
  end
  
  def dir_n(dir)
    case dir
    when :right then 1+0i
    when :left then -1+0i
    when :up then 0+1i
    when :down then 0-1i
    end
  end
  
  def up; @up ||= SQUARES_BY_POS[pos+dir_n(:up)] end
  def down; @down ||= SQUARES_BY_POS[pos+dir_n(:down)] end
  def left; @left ||= SQUARES_BY_POS[pos+dir_n(:left)] end
  def right; @right ||= SQUARES_BY_POS[pos+dir_n(:right)] end
  
  def adjacent_squares
    (-1..1).flat_map do |x|
      (-1..1).map do |y|
        next if x.zero? && y.zero?
        SQUARES_BY_POS[pos + (x + y * 1i)]
      end.compact
    end
  end
  
  def distance_to_origin
    pos.real.abs + pos.imaginary.abs
  end
  
  def next_dir
    dirs = %i[right up left down].select { |d| send(d) }
    dir =
      case dirs
      when [] then :right
      when %i[left] then :up
      when %i[down] then :left
      when %i[right down] then :left
      when %i[right] then :down
      when %i[right up] then :down
      when %i[up] then :right
      when %i[up left] then :right
      when %i[left down] then :up
      else
        pp num => dirs
          dirs.last
      end
    dir_n(dir)
  end
end

SQUARES_BY_POS = {}
SQUARES_BY_N = Hash.new do |h, n|
  prior = h[n-1]
  square = Square.new(prior.pos + prior.next_dir, n)
  square.value = square.adjacent_squares.sum(&:value)
  SQUARES_BY_POS[square.pos] = square
  h[n] = square
end
SQUARES_BY_POS[0+0i] = SQUARES_BY_N[1] = Square.new(0+0i, 1, 1)

325489.times do |x|
  SQUARES_BY_N[x + 2]
end

#(-5..5).each do |y|
#  (-5..5).each do |x|
#    s = SQUARES_BY_POS[x+y*-1i]
#    print s&.num&.to_s&.rjust(6)
#  end
#  puts
#end

square = SQUARES_BY_N[325489]
pp square.distance_to_origin
1.upto(325489) do |x|
  v = SQUARES_BY_N[x].value
  break p v if v > square.num
end
