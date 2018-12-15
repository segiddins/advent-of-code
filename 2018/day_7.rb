#!/usr/bin/ruby

deps = Hash.new { |h, k| h[k] = [] }

DATA.readlines.each do |l|
	l =~ /^Step (\w+) must be finished before step (\w+) can begin\.$/
	deps[$1]
	deps[$2].unshift($1).tap(&:sort!)
end

#require 'tsort'
#
#steps = TSort.tsort(
#	->(&b) { deps.keys.sort.each(&b) },
#	->(k, &b) { deps[k].each(&b) },
#)
#
#pp steps.join

def f(deps)
	deps = deps.map {|k,v| [k, v.dup] }.to_h
	until deps.empty?
		step = deps.to_a.sort_by(&:first).find { |k, v| v.empty? }.first
		print step
		deps.delete(step)
		deps.each_value { |v| v.delete(step) }
	end
	puts
end
f(deps)



def g(deps)
	step_dur = 60
	worker_count = 5
	workers = {}
	0.upto(worker_count.pred) { |i| workers[i] = [] }
	deps = deps.map {|k,v| [k, v.dup] }.to_h
	s_m = {}
	0.upto(1_000_000_000) do |s|
		Array(s_m[s]).each {|step| deps.each_value {|v| v.delete(step) } }

		workers.each do |w, v|
			next unless v[s].nil?

			if step = deps.to_a.sort_by(&:first).find { |k, v| v.empty? }&.first
				done_time = s + step.to_i(36) - 10 + step_dur
				s.upto(done_time) { workers[w] << step }
				(s_m[done_time.succ] ||= []) << step
				deps.delete(step)
			else
				v << '.'
			end
		end

		break if deps.empty? and s_m.map(&:first).max <= s
	end

#	0.upto(15) do |s|
#		print "#{s} ".rjust(3)
#		workers.each_value {|v| print ' ', v[s], ' ' }
#		puts
#	end

	puts workers.first.last.size.pred
end
g(deps)

__END__
Step C must be finished before step P can begin.
Step V must be finished before step Q can begin.
Step T must be finished before step X can begin.
Step B must be finished before step U can begin.
Step Z must be finished before step O can begin.
Step P must be finished before step I can begin.
Step D must be finished before step G can begin.
Step A must be finished before step Y can begin.
Step R must be finished before step O can begin.
Step J must be finished before step E can begin.
Step N must be finished before step S can begin.
Step X must be finished before step H can begin.
Step F must be finished before step L can begin.
Step S must be finished before step I can begin.
Step W must be finished before step Q can begin.
Step H must be finished before step K can begin.
Step K must be finished before step Q can begin.
Step E must be finished before step L can begin.
Step Q must be finished before step O can begin.
Step U must be finished before step G can begin.
Step L must be finished before step O can begin.
Step Y must be finished before step G can begin.
Step G must be finished before step I can begin.
Step M must be finished before step I can begin.
Step I must be finished before step O can begin.
Step A must be finished before step N can begin.
Step H must be finished before step O can begin.
Step T must be finished before step O can begin.
Step H must be finished before step U can begin.
Step A must be finished before step I can begin.
Step B must be finished before step R can begin.
Step V must be finished before step T can begin.
Step H must be finished before step M can begin.
Step C must be finished before step A can begin.
Step B must be finished before step G can begin.
Step L must be finished before step Y can begin.
Step T must be finished before step J can begin.
Step A must be finished before step R can begin.
Step X must be finished before step L can begin.
Step B must be finished before step L can begin.
Step A must be finished before step F can begin.
Step K must be finished before step O can begin.
Step W must be finished before step M can begin.
Step Z must be finished before step N can begin.
Step Z must be finished before step S can begin.
Step R must be finished before step K can begin.
Step Q must be finished before step L can begin.
Step G must be finished before step O can begin.
Step F must be finished before step Y can begin.
Step V must be finished before step H can begin.
Step E must be finished before step I can begin.
Step W must be finished before step Y can begin.
Step U must be finished before step I can begin.
Step F must be finished before step K can begin.
Step M must be finished before step O can begin.
Step Z must be finished before step H can begin.
Step X must be finished before step S can begin.
Step J must be finished before step O can begin.
Step B must be finished before step I can begin.
Step F must be finished before step H can begin.
Step D must be finished before step U can begin.
Step E must be finished before step M can begin.
Step Z must be finished before step X can begin.
Step P must be finished before step L can begin.
Step W must be finished before step H can begin.
Step C must be finished before step D can begin.
Step A must be finished before step X can begin.
Step Q must be finished before step I can begin.
Step R must be finished before step Y can begin.
Step B must be finished before step A can begin.
Step N must be finished before step L can begin.
Step H must be finished before step G can begin.
Step Y must be finished before step M can begin.
Step L must be finished before step G can begin.
Step G must be finished before step M can begin.
Step Z must be finished before step R can begin.
Step S must be finished before step Q can begin.
Step P must be finished before step J can begin.
Step V must be finished before step J can begin.
Step J must be finished before step I can begin.
Step J must be finished before step X can begin.
Step W must be finished before step O can begin.
Step B must be finished before step F can begin.
Step R must be finished before step M can begin.
Step V must be finished before step S can begin.
Step H must be finished before step E can begin.
Step E must be finished before step U can begin.
Step R must be finished before step W can begin.
Step X must be finished before step Q can begin.
Step N must be finished before step G can begin.
Step T must be finished before step I can begin.
Step L must be finished before step M can begin.
Step H must be finished before step I can begin.
Step U must be finished before step M can begin.
Step C must be finished before step H can begin.
Step P must be finished before step H can begin.
Step J must be finished before step F can begin.
Step A must be finished before step O can begin.
Step X must be finished before step M can begin.
Step H must be finished before step L can begin.
Step W must be finished before step K can begin.
