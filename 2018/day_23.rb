Pos =
  Struct.new(:x, :y, :z) do
    def distance(to:)
      %i[x y z].map { |c| send(c) - to.send(c) }.sum(&:abs)
    end
  end

Bot = Struct.new(:pos, :r)

def parse(s)
  s.each_line.map do |l|
    raise l unless l =~ /pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/
    Bot.new(Pos.new($1.to_i, $2.to_i, $3.to_i), $4.to_i)
  end
end

input = <<-EOS
pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
EOS

input = File.read(File.expand_path('day_23_input.txt', __dir__))

bots = parse(input)
bot = bots.max_by(&:r)
in_range = bots.select { |b| b.pos.distance(to: bot.pos) <= bot.r }

pp in_range.size

class PriorityQueue
  def initialize
    @h = Hash.new { |h, k| h[k] = [] }
  end
  def <<(e, p = e)
    @h[p] << e
  end
  def pop
    min_p = @h.each_key.min
    a = @h[min_p]
    a.pop.tap { @h.delete(min_p) if a.empty? }
  end
end

# https://www.reddit.com/r/adventofcode/comments/a8s17l/2018_day_23_solutions/ecdqzdg/
q = PriorityQueue.new
bots.each do |bot|
  d = bot.pos.x.abs + bot.pos.y.abs + bot.pos.z.abs
  q << [[0, d - bot.r].max, 1]
  q << [d + bot.r + 1, -1]
end
count = 0
max_count = 0
result = 0

while (e = q.pop)
  dist, e = e
  count += e
  if count > max_count
    result = dist
    max_count = count
  end
end

pp result
