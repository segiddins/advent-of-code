require 'set'

Constellation = Struct.new(:points) do
  def merge(other)
    if other.points.any? { |pt| distance(pt) <= 3 }
      [Constellation.new(points + other.points)]
    else
      [self, other]
    end
  end

  def distance(pt)
    points.map do |p|
      pt.distance(p)
    end.min
  end
end

Pt = Struct.new(:x,:y,:z,:t) do
  def distance(other)
    members.sum {|m| (send(m) - other.send(m)).abs }
  end
end

def parse(s)
  s.each_line.map do |l|
    Pt.new(*l.strip.split(?,).map(&:to_i))
  end
end

input = <<~EOS
1,-1,0,1
2,0,-1,0
3,2,-1,0
0,0,3,1
0,0,-1,-1
2,3,-2,0
-2,2,0,0
2,-2,0,-1
1,-1,0,-1
3,2,0,2
EOS
input = File.read(File.expand_path('day_25_input.txt', __dir__))

points = parse(input)

neighboring_points = Hash.new { |h,k| h[k] = Set.new }

points.combination(2) do |a, b|
  neighboring_points[a] << a
  neighboring_points[b] << b
  next unless a.distance(b) <= 3
  neighboring_points[a] << b
  neighboring_points[b] << a
end

constellations_by_pt = Hash.new { |h,k| h[k] = Constellation.new(Set.new) }

neighboring_points.each do |pt, new_pts|
  constellation = constellations_by_pt[pt]
  pts = constellations_by_pt[pt].points
  pts.merge new_pts
  pts.to_a.each do |p|
    oc = constellations_by_pt[p]
    next if oc.equal?(constellation)
    pts.merge oc.points
    constellations_by_pt[p] = constellation
  end
end

pp constellations_by_pt.values.uniq.size
