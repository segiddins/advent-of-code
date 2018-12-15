#!/usr/bin/env ruby

require 'set'

players_count = 423
last_marble = 71944

Node = Struct.new(:value, :pre, :tail) do
  def <<(obj)
    self.tail = Node.new(obj, self, tail)
    self.tail.tail.pre = self.tail
    self.tail
  end
  
  def circle
    seen = Set.new
    current = self
    circle = []
    while seen.add?(current)
      circle << current.value
      current = current.tail
    end
    circle
  end
  
  def advanced(n=1)
    x = self
    if n > 0
      n.times { x = x.tail }
    else
      (-1 * n).times { x = x.pre }
    end
    x
  end
  
  def remove
    pre.tail = tail
    tail.pre = pre
    
    tail
  end
end

def play(players_count:, last_marble:)
  current_marble = Node.new(0)
  current_marble.tail = current_marble.pre = current_marble

  scores = players_count.times.each_with_object({}) { |i, h| h[i] = 0 }

  1.upto(last_marble) do |i|
    player = i % players_count
    current_marble =
      if i % 23 == 0
  #      p current_marble.value
        current_marble = current_marble.advanced(-7)
  #      p current_marble.value
        scores[player] += i
        scores[player] += current_marble.value
        current_marble.remove
      else
        current_marble = current_marble.advanced
        current_marble << i
      end
      
  #    p player
  #    p current_marble.circle
  end

  pp scores.max_by(&:last).last
end

play(players_count: players_count, last_marble: last_marble)
play(players_count: players_count, last_marble: last_marble * 100)
