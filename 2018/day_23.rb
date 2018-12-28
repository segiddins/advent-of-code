Pos = Struct.new(:x,:y,:z) do
  def distance(to:)
    %i[x y z].map {|c| send(c) - to.send(c) }.sum(&:abs)
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
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
EOS

input = File.read(File.expand_path('day_23_input.txt', __dir__))

bots = parse(input)
bot = bots.max_by(&:r)
in_range = bots.select {|b| b.pos.distance(to: bot.pos) <= bot.r }
p in_range.size