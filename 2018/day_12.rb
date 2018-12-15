#!/usr/bin/ruby

state = []

state, _, *notes = DATA.each_line.map(&:chomp)
state = state.sub!(/^initial state: /, '')

def run_gen(state, notes)
  h = {}
  reg = []
  notes.each do |note|
    _, l, c, r, v = note.match(/\A(..)(.)(..) => (.)\z/).to_a
    reg << /(?<=#{Regexp.escape l})#{Regexp.escape c}(?=#{Regexp.escape r})/
    h[[l,c,r].join] = v
  end
  state = "...#{state}...".gsub(Regexp.union(*reg)) do
    m = Regexp.last_match
    k = [m.pre_match[-2, 2], m.to_s, m.post_match[0,2]].join

    h.fetch(k) || '.'
  end.sub(/\.*\z/, '')
  pre_a = state.dup
  state.sub!(/\A\.*/, '')
  [state, pre_a.size - state.size]
end

def score(state, adj)
  state.each_char.each_with_index.sum do |c, i|
    if c == '.'
      0
    else
      i - adj
    end
  end
end


require 'set'
adj = 0
seen_a = [state]
adj_a = [adj]
score_a = [score(state, adj)]
seen = [state].to_set
n = 50_000_000_000
10_000.times do |i|
  state, a = run_gen(state, notes)
  adj += 3 - a
  seen_a << state
  adj_a << adj
  score_a << score(state, adj)
  break unless seen.add?(state)
end

puts score_a[20]

def projected_score(scores, n)
  return scores[n] if scores.length > n
  (scores[-1] - scores[-2]) * (n - scores.size + 1) + scores.last
end

p projected_score(score_a, n)

__END__
initial state: ###....#..#..#......####.#..##..#..###......##.##..#...#.##.###.##.###.....#.###..#.#.##.#..#.#

..### => #
..... => .
..#.. => .
.###. => .
...## => #
#.### => .
#.#.# => #
##..# => .
##.## => #
#...# => .
..##. => .
##.#. => .
...#. => .
#..#. => #
.#### => #
.#..# => #
##... => #
.##.# => .
....# => .
#.... => .
.#.#. => #
.##.. => .
###.# => #
####. => .
##### => #
#.##. => #
.#... => #
.#.## => #
###.. => #
#..## => .
#.#.. => #
..#.# => .
