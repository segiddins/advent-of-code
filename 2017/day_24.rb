#!/usr/bin/ruby

Port = Struct.new(:a,:b, :to_s) do
	def match_left(left)
		case left.b
		when a
			self
		when b
			reversed
		end
	end

	def reversed
		Port.new(b, a, to_s).freeze
	end
end

ports = DATA.readlines.map { |l| Port.new *l.chomp.split(?/, 2).map(&:to_i).sort, l.chomp }.each(&:freeze).sort_by(&:to_s).freeze

def make_chains(left, available,cache:{})
	cache[[left, available]] ||= begin
		available.each_with_index.flat_map do |r, i|
			next unless r = r.match_left(left)

			a2 = available.dup
			a2.delete_at(i)
			make_chains(r, a2.freeze,cache:cache).map { |c| [left] + c }.freeze
		end.compact.unshift([], [left]).uniq
	end
end

chains = make_chains(Port.new(0,0), ports)
chains.map! { |c| c[1..-1] }.compact!.reject!(&:empty?)

def strength(chain)
	chain.sum { |p| p.a + p.b }
end

ls =  chains.map {|c| [c.length, strength(c)] }
p ls.map(&:last).max
p ls.max_by {|l,s| [l, s] }.last

__END__
24/14
30/24
29/44
47/37
6/14
20/37
14/45
5/5
26/44
2/31
19/40
47/11
0/45
36/31
3/32
30/35
32/41
39/30
46/50
33/33
0/39
44/30
49/4
41/50
50/36
5/31
49/41
20/24
38/23
4/30
40/44
44/5
0/43
38/20
20/16
34/38
5/37
40/24
22/17
17/3
9/11
41/35
42/7
22/48
47/45
6/28
23/40
15/15
29/12
45/11
21/31
27/8
18/44
2/17
46/17
29/29
45/50
