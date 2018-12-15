#!/usr/bin/ruby

require 'set'

WALL = Object.new.tap { |o| def o.char; '#'; end }.freeze
DIRS = [1i, -1+0i, 1+0i, -1i].freeze

# This works but it's stupid slow, I think it ends up examening every point on the board
#
#def path(from:,to:,board:,trail:Set.new,bests:{})
#	k = [from,to]
#	if b = bests[k]
#		return b
#	end
#	return unless trail.add?(from)
#	return [from] if from == to
#
#	return unless n = [1i, -1+0i, 1+0i, -1i].shuffle.map do |dir|
#		np = from+dir
#		next if board[np]
#		np = path(from:np, to:to,board:board,trail:trail.dup, bests:bests)
#	end.compact.min_by { |p| [p.size, p.first.imaginary.abs, p.first.real] }
#	bests[k] = [from] + n
#	[from] + n
#end

class PriorityQueue
	def initialize
		@h = Hash.new { |h, k| h[k] = [] }
	end

	def <<(o, p)
		@h[p] << o
	end

	def pop_front
		p, a = @h.min_by(&:first)
		a.min_by { |z| [z.imag.abs, z.real] }.tap { |z| a.delete(z); @h.delete(p) if a.empty? }
	end

	def empty?
		@h.empty?
	end
end

def path(from:,to:,board:, came_from: { from => nil }, cost_so_far: { from => 0 })
	frontier = PriorityQueue.new
	frontier.<<(from, 0)

	heuristic = ->(a,b) { 1 } # needs to be constant to be able to reuse computations

	while !frontier.empty?
		current = frontier.pop_front

		break if current == to

		neighbors = DIRS.map {|d|current+d}.reject {|p| board[p] }
		neighbors.each do |n|
			new_cost = cost_so_far[current] + 1

			came_from_current = !cost_so_far.key?(n)
			came_from_current ||= new_cost < cost_so_far[n]
			came_from_current ||= new_cost == cost_so_far[n] &&
				(([current.imag.abs, current.real] <=> [came_from[n].imag.abs, came_from[n].real]) < 0)

			if came_from_current
				cost_so_far[n] = new_cost
				priority = new_cost + heuristic[to, n]
				frontier.<<(n, priority)
				came_from[n] = current
			end
		end
	end

	path = []
	loop do
		path << to
		break unless to = came_from[to]
	end
	return unless path.last == from

	path.reverse
end

Player = Struct.new(:char, :pos, :pid, :hp, :ap, :board) do
	def move
		targets = self.targets
		return false if targets.empty?

		adjacent_target = nil
		return true if !(adjacent_target = self.adjacent_target) && (potential_targets = targets.map { |t| [t, t.open_adjacents] } and potential_targets.flat_map(&:last).empty?)

		unless adjacent_target
			bests = {}
			came_from, cost_so_far = { pos => nil }, { pos => 0 }
			paths = potential_targets.map {|t, ps| [t, ps.map { |p| path(from:pos,to:p,board:board,came_from:came_from,cost_so_far:cost_so_far) }.compact.min_by(&:size)] }
			paths.delete_if { |_, ps| ps.nil? }
			return true if paths.empty?
			_, best_path = paths.min_by { |t, p| [p.size, t.pos.imaginary.abs, t.pos.real] }
			board.delete(pos)
			self.pos = best_path[1]
			board[pos] = self
		end

		if adjacent_target = self.adjacent_target
			attack(adjacent_target)
		end
		true
	end

	def targets
		board.each_value.grep(Player).select {|p|p.char != char}
	end

	def adjacent_positions
		DIRS.map {|p| pos+p }
	end

	def open_adjacents
		adjacent_positions.reject {|p|board.key?(p)}
	end

	def adjacent_target
		adjacent_positions.map {|p| board[p] }.grep(Player).select {|t| t.char != char }.
			min_by {|t| [t.hp, t.pos.imaginary.abs, t.pos.real] }
	end

	def attack(target)
		target.hp -= ap
		if target.hp <= 0
			target.board.delete(target.pos)
			target.board = nil
		end
	end
end

def read_board(s, ap:)
	board = {}
	s.each_line.each_with_index do |l, y|
		l.each_char.each_with_index do |c, x|
			pos=x-y*1i
			case c
			when '#' then board[pos] = WALL
			when 'G', 'E' then board[pos] = Player.new(c, pos, board.size, 200, ap[c], board)
			end
		end
	end
	board
end

def print_board(board)
	xn, xx = board.each_key.map(&:real).minmax
	yn, yx = board.each_key.map(&:imaginary).map { |i| i.abs }.minmax

	yn.upto(yx) do |y|
		players = []
		xn.upto(xx) do |x|
			pos=x-y*1i
			piece = board[pos]
			players << piece if piece && piece&.char != '#'
			print piece&.char || '.'
		end
		puts "  #{players.map {|p| "#{p.char}(#{p.hp})"}.join(', ')}".rstrip
	end
end

def play(string, ap: { 'E' => 3, 'G' => 3}, debug: false)
	board = read_board(string, ap:ap)
	turn = 0
	all_players = board.each_value.grep(Player).to_a
	loop do
		if debug
			puts turn
			print_board(board)
		end

		break unless board.each_value.grep(Player).sort_by { |p| [p.pos.imaginary.abs, p.pos.real] }.all? do |player|
			next true unless player.board
			player.move
		end
		turn += 1
	end

	hp = board.each_value.grep(Player).sum(&:hp)
	{ winner: board.each_value.grep(Player).first.char, turn: turn, hp: hp, outcome: hp * turn, deaths: (all_players - board.each_value.grep(Player)).map(&:char) }
end

mine = <<'EOS'
################################
###.GG#########.....#.....######
#......##..####.....G.G....#####
#..#.###...######..........#####
####...GG..######..G.......#####
####G.#...########....G..E.#####
###.....##########.........#####
#####..###########..G......#####
######..##########.........#####
#######.###########........###.#
######..########G.#G.....E.....#
######............G..........###
#####..G.....G#####...........##
#####.......G#######.E......#..#
#####.......#########......E.###
######......#########........###
####........#########.......#..#
#####.......#########.........##
#.#.E.......#########....#.#####
#............#######.....#######
#.....G.G.....#####.....########
#.....G.................########
#...G.###.....#.....############
#.....####E.##E....##.##########
##############.........#########
#############....#.##..#########
#############.#######...########
############.E######...#########
############..####....##########
############.####...E###########
############..####.E.###########
################################
EOS

last_test = <<'EOS'
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
EOS

first_test = <<'EOS'
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
EOS

string = mine
pp play(string, debug: false)[:outcome]

30.upto(100).each do |e|
	r = play(string, ap: {'G'=>3, 'E'=>e})
	next unless r[:deaths].count('E').zero?
	pp r[:outcome]
	break
end
