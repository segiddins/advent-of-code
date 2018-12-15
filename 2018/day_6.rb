#!/usr/bin/env ruby

points = DATA.readlines.map {|l| l.split(/, /).map(&:to_i) }

min_x = points.map(&:first).min
max_x = points.map(&:first).max

min_y = points.map(&:last).min
max_y = points.map(&:last).max

def manhattan(p1, p2)
	(p1.first - p2.first).abs + (p1.last - p2.last).abs
end

a = {}
b = 0
points.each { |pt| a[pt] = 0 }

min_x.upto(max_x) do |x|
	min_y.upto(max_y) do |y|
		pts = points.map do |pt|
			[pt, manhattan(pt, [x, y])]
		end.sort_by(&:last)
		unless pts[0].last == pts[1].last
			a[pts.first.first] += 1
		end
		if pts.sum(&:last) < 10_000
			b += 1
		end
	end
end

a.delete_if { |(x, y), _| [min_x, max_x].include?(x) || [min_y, max_y].include?(y) }
#b.delete_if { |(x, y), _| [min_x, max_x].include?(x) || [min_y, max_y].include?(y) }

pp a.values.max

pp b

__END__
81, 46
330, 289
171, 261
248, 97
142, 265
139, 293
309, 208
315, 92
72, 206
59, 288
95, 314
126, 215
240, 177
78, 64
162, 168
75, 81
271, 258
317, 223
210, 43
47, 150
352, 116
316, 256
269, 47
227, 343
125, 290
245, 310
355, 301
251, 282
353, 107
254, 298
212, 128
60, 168
318, 254
310, 303
176, 345
110, 109
217, 338
344, 330
231, 349
259, 208
201, 57
200, 327
354, 111
166, 214
232, 85
96, 316
151, 288
217, 339
62, 221
307, 68
