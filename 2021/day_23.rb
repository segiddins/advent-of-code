#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
$input = DATA.read
$lines = $input.split("\n")

COST = { 'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }

GOALS = { 'A' => 3, 'B' => 5, 'C' => 7, 'D' => 9 }

def read_grid(s)
  grid = {}
  s
    .split("\n")
    .each_with_index do |l, y|
      l.chars.each_with_index do |c, x|
        grid[Point.new(x, y)] = c unless ['#', ' '].include?(c)
      end
    end
  grid
end

class PriorityQueue
  def initialize
    @h = Hash.new { |h, k| h[k] = [] }
  end

  def push(e, p = e)
    @h[p] << e
  end

  def pop
    min_p = @h.each_key.min
    a = @h[min_p]
    a.pop.tap { @h.delete(min_p) if a.empty? }
  end
end

def print_grid(grid)
  0.upto(10) do |y|
    l = 0.upto(12).map { |x| grid[Point.new(x, y)] || '#' }.join
    puts l
    break if y > 0 && l =~ /^#+$/
  end
  puts

  grid
end

def settled?(current, pt, v, bottom_y)
  pt.x == GOALS[v] &&
    pt.y.upto(bottom_y).all? { |y| current[Point.new(pt.x, y)] == v }
end

def solve(grid)
  pq = PriorityQueue.new
  pq.push(grid, 0)

  cost_so_far = {}
  cost_so_far[grid] = 0
  came_from = { grid => nil }

  goal =
    grid.map do |pt, v|
      next [pt, v] if v == '.'

      next [pt, 'A'] if pt.x == 3
      next [pt, 'B'] if pt.x == 5
      next [pt, 'C'] if pt.x == 7
      next [pt, 'D'] if pt.x == 9

      raise
    end.to_h

  bottom_y = goal.each_key.map(&:y).max

  while current = pq.pop
    move_options =
      current
        .reject { |pt, v| v == '.' }
        .reject do |pt, v|
          # remove those that have finally made it to their room bottom!

          settled?(current, pt, v, bottom_y)
        end

    in_hallway = move_options.select { |pt, _| pt.y == 1 }
    unblocked_in_room =
      move_options.select do |pt, _|
        1.upto(pt.y - 1).all? { |y_| current[Point.new(pt.x, y_)] == '.' }
      end

    unblocked_in_room.each do |pt, v|
      hallway_x_options = []
      pt
        .x
        .upto(12) do |x_|
          next if [3, 5, 7, 9].include?(x_)
          break if current[Point.new(x_, 1)] != '.'
          hallway_x_options << x_
        end
      pt
        .x
        .downto(0) do |x_|
          next if [3, 5, 7, 9].include?(x_)
          break if current[Point.new(x_, 1)] != '.'
          hallway_x_options << x_
        end

      hallway_x_options
        .map { |x| Point.new(x, 1) }
        .each do |hw|
          prime = current.merge(pt => '.', hw => v)

          # puts 'Prime'
          # print_grid prime

          next_cost =
            cost_so_far[current] +
              COST[v] * ((pt.x - hw.x).abs + (pt.y - hw.y).abs)
          best_next_cost = cost_so_far[prime]
          if !best_next_cost or best_next_cost > next_cost
            cost_so_far[prime] = next_cost
            came_from[prime] = current

            pq.push(
              prime,
              [
                # -current.count { |pt, v| settled?(current, pt, v, bottom_y) },
                next_cost,
              ],
            )
          end
        end
    end

    unblocked_in_room
      .merge(in_hallway)
      .each do |pt, v|
        desired_x = GOALS[v]

        # make sure can move horizontal
        if Range
             .new(*[pt.x, desired_x].minmax)
             .any? do |x_opt|
               pt_opt = Point.new(x_opt, 1)
               pt_opt != pt && current[pt_opt] != '.'
             end
          next
        end

        top = Point.new(desired_x, 2)
        next unless current[top] == '.'

        bottom = Point.new(desired_x, 3)

        moves = (pt.x - desired_x).abs
        moves += pt.y - 1 # moves needed to get up to hallway
        prime = nil

        case current[bottom]
        when '.'
          # pp v => { pt => bottom }
          prime = current.merge(bottom => v, pt => '.')
          moves += 2
        when v
          # pp v => { pt => top }
          prime = current.merge(top => v, pt => '.')
          moves += 1
        else
          next
        end

        next_cost = cost_so_far[current] + COST[v] * moves
        best_next_cost = cost_so_far[prime]
        if !best_next_cost or best_next_cost > next_cost
          cost_so_far[prime] = next_cost
          came_from[prime] = current

          pq.push(
            prime,
            [
              # -current.count { |pt, v| settled?(current, pt, v, bottom_y) },
              next_cost,
            ],
          )
        end
      end
  end

  rev = [goal]
  loop do
    c = came_from[rev.last]
    break unless c
    rev << c
  end

  cost =
    cost_so_far.fetch(goal) do
      raise 'Could not fetch cost for goal -- did not find'
    end

  # rev.reverse_each do |state|
  #   puts "Cost so far: #{cost_so_far[state]} -- added #{cost_so_far[state] - cost_so_far.fetch(came_from[state], 0)}"
  #   print_grid state
  # end

  cost
end

def part1
  solve(read_grid $input)
end

def part2
  lines = $lines.dup
  lines.insert(-3, *<<-S.split("\n"))
  #D#C#B#A#
  #D#B#A#C#
    S

  puts lines

  solve(read_grid lines.join("\n"))
end

pp part1
pp part2

__END__
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
