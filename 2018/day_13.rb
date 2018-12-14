#!/usr/bin/env ruby

class Cart
  attr_reader :position
  def initialize(position, direction)
    @position = position
    @direction = direction
    @next_turn = :left
  end
  
  def to_s
    case @direction
    when 1+0i then '>'
    when -1+0i then '<'
    when 0+1i then '^'
    when 0-1i then 'v'
    end + " #{position.real},#{-position.imaginary}"
  end
  
  def turn!
    @next_turn, turn =
      case @next_turn
      when :left then [:straight, 1i]
      when :straight then [:right, 1]
      when :right then [:left, -1i]
      end
    @direction *= turn
  end
  
  def run!(track)
    raise "#{self} if off the rails" unless track
    case track.char
    when '|', '-'
      @position += @direction
    when '+'
      turn!
      @position += @direction
    when '/'
      @direction =
        case @direction
        when 1+0i then 1i
        when 1i then 1
        when -1+0i then -1i
        when 0-1i then -1
        end
      @position += @direction
    when "\\"
      @direction =
        case @direction
        when 1+0i then -1i
        when 1i then -1
        when -1+0i then 1i
        when 0-1i then 1
        end
      @position += @direction
    end
  end
end
Track = Struct.new(:position, :char)

tracks = {}
carts = []

DATA.readlines.each_with_index do |l, y|
  l.each_char.each_with_index do |c, x|
    pos = x + y*-1i
    case c
    when ' ', "\n"
      next
    when '>'
      carts << Cart.new(pos, 1+0i)
      c = '-'
    when '<'
      carts << Cart.new(pos, -1+0i)
      c = '-'
    when 'v'
      carts << Cart.new(pos, 0-1i)
      c = '|'
    when '^'
      carts << Cart.new(pos, 0+1i)
      c = '|'
    end
    
    tracks[pos] = Track.new(pos, c)
  end
end

def print_track(tracks, carts)
  carts_by_pos = carts.each_with_object({}) { |c,h| h[c.position] = c }
  (0..-tracks.each_value.map(&:position).map(&:imaginary).min).each do |y|
    (0..tracks.each_value.map(&:position).map(&:real).max).each do |x|
      pos = x+y*-1i
      print carts_by_pos[pos]&.to_s&.[](0,1) || tracks[pos]&.char || ' '
    end
    puts
  end
end

#print_track(tracks, carts)

first_collision = nil
loop do
  almost_done = carts.size <= 1
  collisions = []
  carts.sort_by {|c| c.position.magnitude }.each do|c|
    c.run!(tracks[c.position])

    if collision = carts.group_by(&:position).each_value.select {|v| v.size > 1 } and collision.size > 0
      unless first_collision
        puts collision.first.first.position
        first_collision = true
      end
      collisions.concat(*collision)
    end
  end

  carts -= collisions
  collisions = []
  
#  print_track(tracks, carts)
  break(puts carts.first&.position) if carts.size <= 1
end

__END__
                                    /----------------------------------------------------------------------\                  /------------\          
        /----------\  /-------------+------------------------------------------------\                     |                  |            |          
      /-+----------+--+-------------+--\                                             |  /-----------\      |                  |            |          
      | |          |  |             |  |                     /-----------------------+--+-----------+------+------------------+------------+-------\  
      | |          |  |             |  |                     |          /------------+--+-----------+------+---------------\  |            |       |  
    /-+-+----------+--+-------------+--+---------------------+-\        |     /------+--+-----------+------+---------------+\ |            |       |  
 /--+-+-+----------+--+-------------+--+---\                 | |        |     |      |  |           |      |               || |            |       |  
 |  | | | /--------+--+-------------+--+\  |                 | |        |     |      |  |           |      |               || |  /---------+-----\ |  
 |  | | | |     /--+--+----->-------+--++--+----------------\| |        |     |      |  |           |      |      /--------++-+--+---------+-\   | |  
 |  | | | |     |  |  |             |  ||  | /<-------------++-+-\ /----+-----+------+--+-----------+------+------+--------++-+--+\        | |   | |  
 |  | | | |     |  |  |            /+--++--+-+--------------++-+-+-+----+---->+------+--+-----------+------+------+--------++-+--++-----\  | |   | |  
 |  | | | |     |  |  |            ||  ||  | |              || |/+-+----+-----+------+--+-----------+------+\     |        || |  ||     |  | |   | |  
 |  | | | |     |  | /+------------++--++--+-+--------------++-+++-+-\  |     |      |  |           |      ||     |        || |  ||     |  | |   | |  
 | /+-+-+-+-----+--+-++------------++--++--+-+--------------++-+++-+-+--+-----+--\   |  |           |      ||     |        || |  ||     |  | |   | |  
 | || | | |     |  | ||            ||  ||  | |              ||/+++-+-+--+-----+--+---+--+-----------+------++-----+--------++-+-\||     |  | |   | |  
 \-++-+-+-+-----+--+-++------------++--++--/ |              |||||| | |/-+-----+--+---+--+-----------+------++-----+-----\  || | |||     |  | |   | |  
   || | | |     |  | ||   /--------++--++----+--------------++++++-+-++-+-----+--+---+--+-----------+------++--\  |     |  || | |||     |  | |   | |  
   || | | |     |  | ||   |        ||  ||    |    /---------++++++-+-++-+-----+--+---+--+-----------+------++--+--+-\   |  || | |||     |  | |   | |  
   || | | |     |/-+-++---+--------++--++----+----+\ /------++++++-+-++-+-----+--+---+--+-----\     |      ||  |  | |   |  || | |||     |  | |   | |  
   || |/+-+-----++-+<++---+--------++--++----+\   || |      |||||| | || |     |  |   |  |     |     |      ||  |  | |   |  || | |||     |  | |   | |  
   || ||| |     || | ||   |        ||  ||    ||   || |      |||||| \-++-+-----+--+---+--+-----+-----+------++--+--+-+---+--++-+-++/     |  | |   | |  
   || ||| |     || | ||   |        ||  ||    ||   || |      ||||||   || |     |  |   |  |     |     |     /++--+--+\|   |  || | ||      |  | |   | |  
   || |||/+-----++-+-++---+--------++--++----++---++-+------++++++-\ || |     |  |   |  |     |     |    /+++--+--+++---+->++-+\||      |  | |   | |  
   || |||||     || | ||   | /------++--++----++---++-+------++++++-+-++-+-----+--+---+--+-----+-----+---\||||  |  |||   |  || ||||      |  | |   | |  
   || ||||\-----++-+-++---+-+------++--+/    ||   || |  /---++++++-+-++-+-----+--+---+--+-----+----\|   |||||  |  |||   |  || ||||      |  | |   | |  
   || ||||    /-++-+-++---+-+------++--+-----++---++-+--+---++++++-+-++-+--\  |  |/--+--+-----+----++---+++++--+--+++---+--++-++++------+--+-+---+-+-\
   || ||||    | || | ||   | |      ||  |     ||   || |  |   |\++++-+-++-+--+--+--++--+--+-----+----++---+++++--+--+++---+--++-++++------+--+-+---+-/ |
   || ||||    | || | ||/--+-+------++-\| /---++---++-+--+--\| |||| | || |  |  \--++--+--+-----+----++---+++++--+--+++---+--+/ ||||      |  | |   |   |
   || ||||    | || | |\+--+-+------++-++-+---++---++-+--+--++-++++-+-++-+--+-----++--/  | /---+----++---+++++--+--+++---+--+--++++------+--+-+\  |   |
   || ||||    | || | | |  | |      || || |   ||   || |  |  || |||| | || |  |     ||   /-+-+---+----++---+++++--+--+++---+--+\ ||||      |  | |^  |   |
   || ||||    | || | | |  | |      || || |   ||   || |  |  || ||||/+-++-+--+-----++---+-+-+---+----++---+++++--+\ |||   |  || ||||      |  | ||  |   |
   || ||||    | || | | |  | |      |\-++-+---++---++-+--+--++-++++++-++-+--+-----++---+-+-+---+----++---+++/|  || |||   |  || ||||      |  | ||  |   |
   || ||||    | \+-+-+-+--+-+------+--++-+---++---++-+--+--+/ |||||| || |  | /---++---+-+-+---+----++---+++-+--++-+++---+--++-++++------+\ | ||  |   |
   || ||||    |  | | | |  | |      |  || |   ||   ||/+--+--+--++++++-++-+--+-+---++---+-+-+---+----++---+++-+--++-+++---+--++-++++------++-+-++-\|   |
   |\-++++----+--+-+-+-+--+-+------+--++-+---++---++++--+--+--+/|||| || |  | |   ||   | | |   |    ||   ||| |  || |||   |  || ||||      || | || ||   |
   |  |||\----+--+-+-+-+--+-+------+--++-+---++---++++--+--+--+-+++/ || |  | |   ||   | | |   |    ||   ||\-+--++-+/|   |  || ||||      || | || ||   |
   |  |||    /+--+-+-+-+--+-+------+--++-+---++---++++--+--+--+-+++--++-+--+-+---++---+-+-+---+----++---++\ |  || | |   |  || ||||      || | || ||   |
   |  |||    ||  | | | |  | |  /---+--++-+---++---++++--+--+--+-+++--++-+--+-+---++---+-+-+---+----++---+++-+--++-+-+---+--++-++++---\  || | || ||   |
   |  ||| /--++--+-+-+-+--+-+--+---+--++-+---++---++++--+--+--+-+++--++-+--+-+---++\  | | |   |    ||   ||| |  || | |   |  || ||||   |  || | || ||   |
   |  ||| |  ||  | | | |  | | /+---+--++-+---++---++++--+--+--+-+++--++-+--+-+-\ |||  | | |  /+----++---+++-+--++-+-+---+--++-++++---+\ || | || ||   |
   |  ||| |  ||  | | | |  | | ||   |  ||/+---++---++++--+--+--+-+++--++-+--+-+-+-+++--+-+-+--++----++---+++-+-\|| |/+---+--++-++++---++\|| | || ||   |
   |  ||| |  ||  | | | |  | | ||   |  ||||   ||   ||||  |  |  | |||  |\-+--+-+-+-+++--+-+-+--++----++---+++-+-+++-+++---/  || ||||   ||||| | || ||   |
   |  ||| |  ||  | | | |  | | ||   |  |||\---++---++++--+--/  | |||  |  |  | | | |||  | |/+--++----++---+++-+-+++-+++------++-++++-\ ||||| | || ||   |
  /+--+++-+--++--+-+-+-+--+-+-++---+--+++----++---++++--+-----+-+++--+--+--+-+-+\|||  | |||  ||  /-++---+++-+-+++-+++------++-++++-+-+++++-+-++\||   |
  ||  ||| |  ||  | | | |  | | ||   |  |||    ||   |||| /+-----+-+++--+--+--+-+-+++++--+-+++-\|| /+-++---+++-+-+++-+++------++-++++-+-+++++-+-+++++--\|
  ||  ||\-+--++--+-/ | |  | | ||   |  |||   /++---++++-++-----+-+++--+--+--+-+-+++++--+\||| ||| || ||   ||| | ||| |||      || |||| | ||||| | |||||  ||
  ||  ||  |  || /+---+-+--+-+-++---+--+++---+++---++++-++-----+-+++--+--+--+-+-+++++--+++++-+++-++-++---+++-+-+++-+++-----\|| |||| | ||||| | |||||  ||
  ||  ||  |  || ||   | |  | | ||   |  |||   |||   |||| ||     | |||  |  |  | | |||||  ||||| ||| || ||   ||| | ||| |||     ||| |||| | ||||| | |||||  ||
  |\--++--+--++-++---+-+--+-+-++---+--+++---+++---++++-++-----+-+++--+--+--+-+-++/||  ||||| ||| || ||   ||| | ||| |||     ||| |||| | ||||| | |||||  ||
  |   ||/-+--++-++---+-+--+-+-++---+--+++---+++---++++-++-----+-+++--+--+-\| | || ||  ||||| ||| || ||   |||/+-+++-+++-----+++-++++-+-+++++\| |||||  ||
  |   ||| | /++-++---+-+--+-+-++---+--+++---+++---++++-++-----+-+++--+--+-++-+-++-++--+++++-+++-++-++--\||||| ||| |||     ||| |||| | ||||||| |||||  ||
  |   ||| | ||| |\---+-+--+-+-++---+--+++---+++---+/|| ||     | |||  |  | ||/+-++-++--+++++-+++-++-++--++++++-+++-+++-----+++-++++-+\||||||| |||||  ||
  |   ||| | ||| |  /-+-+--+-+-++---+--+++---+++---+-++-++-----+-+++--+--+-++++-++-++--+++++-+++\|| ||  |||||| ||| |\+-----+++-++++-++++/|||| |||||  ||
  |   ||| | ||| |  | | |  | |/++---+--+++---+++---+-++-++-----+-+++\ |  | |||| || ||  ||||| |||||| ||  |||||| ||| | |     ||| ||||/++++-++++-+++++-\||
  |   ||| | ||v |  | | |  | ||||   |  |||   |||   | || ||     | |||| |  | |||| || ||  ||||| |||||| ||  |||||| ||| | |     ||| ||||||||| |||| ||||| |||
  |   ||| | ||| |  | | | /+-++++---+--+++---+++>--+-++-++-----+-++++\|  | |||| || ||  ||||| |||||| ||  |||||| ||| | |     ||| ||||||||| |||| ||||| |||
  |   ||| | ||| |  | | | || ||||   |  |||   |||   | || ||  /--+-++++++--+-++++-++-++--+++++-++++++-++--++++++-+++-+\|     ||| ||||||||| |||| ||||| |||
  |   ||| | ||| |  | | | || ||||   |  |||   |||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||  |||||| ||| |||     ||| ||||||||| |||| ||||| |||
  |   ||| | ||| |  | | | || ||||   |  |||   |||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||  |||||| ||| |||     ||| ||||||||| |||| ||||| |||
  |   ||| | ||| |  | | | || ||||   |  |||   |||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||  |||||| ||| |||     ||| ||||||||| |||| ||||| |||
  |   ||| | ||| |  |/+-+-++-++++---+--+++---+++---+-++-++--+--+-++++++--+-++++-++-++--+++++-++++++-++--++++++\||| |||     ||| ||||||||| |||| ||||| |||
  |   ||| | |v| |  ||| | || ||||   |  |||   |||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||  |||||||||| |||     ||| ||||||||| |||| ||||| |||
 /+---+++-+-+++-+--+++-+-++\||||   |  |||   |||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||  |||||||||| |||     ||| ||||||||| |||| ||||| |||
 ||   ||| | |||/+--+++-+-+++++++---+--+++---+++---+-++-++--+--+-++++++--+-++++-++-++--+++++-++++++-++\ |||||||||| |||     ||| ||||||||| |||| ||||| |||
 ||   ||| | |||||  ||| | |||||||   |  |||   |||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||| |||||||||| |||     ||| ||||||||| |||| ||||| |||
 ||   ||| |/+++++--+++-+-+++++++---+--+++---+++---+-++-++--+--+-++++++--+-++++-++-++--+++++-++++++-+++-++++++++++-+++-\   ||| ||||||||| |||| ||||| |||
 ||   ||| |||||||  ||| |/+++++++---+--+++--\|||   | || ||  |  | ||||||  | |||| || ||  ||||| |||||| ||| |||||||||| ||| |   ||| ||||||||| |||| |||v| |||
 ||   ||| ||||||\--+++-+++++++++---+--+++--++++---+-++-++--+--+-++++++--+-++++-++-++--+++++-++++++-+++-++++++++++-+++-+---/|| ||||||||| |||| ||||| |||
 ||   ||| ||||||   ||| |||||||||  /+--+++--++++---+-++-++--+--+-++++++--+\|||| || ||  ||||| |||||| ||| |||||||||| \++-+----++-+++++++++-++++-/|||| |||
 ||   ||| ||||||   ||| |||||||||  ||  |||  ||||   | || ||  \--+-++++++--++++++-++-++--+++++-++++++-+++-++++++++++--/| |    || ||||||||| ||||  |||| |||
 ||   ||| ||||||   ||\-+++++++++--++--+++--++++---+-++-++-----+-+++++/  |||||| || ^|  ||||| |||||| ||| ||||||||||   | |    || ||||||||| ||||  |||| |||
 ||/--+++-++++++---++--+++++++++--++--+++--++++---+-++-++-----+-+++++---++++++-++-++-\||||| |||||| ||| ||||||||||   | |    || ||||||||| ||||  |||| |||
 |||  ||| ||||||   ||  |||||||||  ||  |||  ||||   |/++-++-----+-+++++---++++++-++-++-++++++-++++++-+++-++++++++++\  | |    || ||||||||| ||||  |||| |||
 |||  \++-++++++---++--+++++++++--++--+/|  ||||/--++++-++-----+-+++++---++++++-++-++-++++++-++++++\||| |||||||||||  | |    || ||||||||| ||||  |||| |||
 |||   || ||||||  /++--+++++++++--++--+-+--+++++--++++-++-----+-+++++--<++++++-++-++-++++++\|||||||||| |||||||||||  | |    || ||||||||| ||||  |||| |||
 |||   || ||||||  ||| /+++++++++--++--+-+--+++++--++++-++-----+-+++++-\ |||||| || || |||\+++++++++++/| |||||||||||  | |    || ||||||||| ||||  |||| |||
 |||   || ||||||  ||| ||||||||||  ||  | |  ||\++--++++-++-----+-+/||| | |||||| || || ||| ||||||||||| | |||||||||||  | |    || ||||||||| ||||  |||| |||
 |||   \+-++++++--+++-++++++++++--++--+-+--++-/|  \+++-++-----+-+-+++-+-++++++-++-++-+++-+++++++++++-+-+++++++++++--/ |    || ||||||||| ||||  |||| |||
 |||    | ||||||  ||| ||||||||||  ||  | |  ||  |   ||| ||     | | ||| | |||||| || || ||| \++++++++++-+-+++++++++++----+----++-+++++/||| ||||  |||| |||
 |||    | ||||||  ||| ||||||||||  ||  | |  ||  |   ||| ||     | | ||| | |||||\-++-++-+++--++++++++++-+-+++++++++++----+----++-+++++-+++-+/||  |||| |||
 |||    | ||||||  ||| ||||||||||  ||  | |  ||  |   ||| ||     | | ||| |/+++++--++-++-+++--++++++++++-+-+++++++++++----+--\ || ||||| ||| | ||  |||| |||
 |||    | ||||||  ||\-++++++++++--++--+-+--++--+---+++-++-----+-+-+++-+++++++--++-++-+++--++++++++++-+-++++++/||||    |  | || ||||| ||| | ||  |||| |||
 |||    | ||||||  ||  ||||||||||  || /+-+--++--+--\||| ||     | | \++-+++++++--++-++-+++--++++++++++-+-++++++-++/|  /-+--+-++\||||| ||| | ||  |||| |||
 |||    | ||||||  ||  ||||||||||  || || |  |\--+--++++-++-----+-+--++-+++++++--++-++-++/  |||||||||| | |||||| || |  | |  | |||||||| ||| | ||  |||| |||
 |||    | ||||\+--++--++++++++++--++-++-+--+---+--++++-++-----+-+--++-+++++/|  || || ||   |||||||||| | |||||| || |  | |  | |||||||| ||| v ||  |||| |||
 |||    | |||| |  ||  ||||||||||  || || |  |   |  |||| ||   /-+-+--++-+++++-+--++-++-++---++++++++++-+-++++++-++-+--+-+-\| |||||||| ||| | ||  |||| |||
 |||    | |||| |/-++--++++++++++--++-++-+--+---+\ |||| ||   | | | /++-+++++-+--++-++-++--\|||||||||| | |||||| || |  | | || |||||||| ||| | ||  |||| |||
 |||   /+-++++-++-++--++++++++++--++\|| |  |   || |\++-++---+-+-+-+++-+++++-+--++-++-++--+++++++++++-+-++++++-++-/  | | || |||\++++-+++-+-+/  |||v |||
 |||   || |||| || ||  ||||||||||  ||||| |  |   || | || ||   | | \-+++-+++++-+--++-++-++--+++++++++++-+-+++++/ ||    | | || ||| |||| ||| | |   |||| |||
 |\+---++-++++-++-++--++++++++++--+++++-+--+---++-+-++-++---+-+---+++-+++++-+--+/ || ||  ||||||||||| | |||||  ||    | | || ||| |||| ||| | |   |||| |||
 | |   || |||| || ||  ||||||||||  ||||| |  |   || | || \+---+-+---+++-+++++-+--+--++-++--+++/||||||| | |||||  ||    | | || ||| |||| ||| | |   |||| |||
 | |   || |||| || ||  ||||||||||  ||||| |  |   || | ||  |   | |   ||| ||||| |  |  \+-++--+++-+++++++-+-+++++--++----+-+-++-+++-++++-+++-+-+---++++-++/
 | |   || |||| || ||  ||||||||||  ||||| |  |   || | \+--+---+-+---+++-+++++-+--+---+-++--+++-+++++++-+-+++++--++----+-+-++-+++-++++-+++-+-+---++/| || 
 | |   || |||| || ||  ||||\+++++--+++++-+--+---++-+--+--+---+-+---+++-+++++-+--+---+-++--+++-+++++++-+-+++++--+/    | | || ||| |||| ||| | |   || | || 
/+-+---++-++++-++-++--++++-+++++--+++++\|  |   || |  |  \---+-+---+++-+++++-+--+---+-++--+++-++++++/ | |||||  |     | | || ||| |||| ||| | |   || | || 
|| |   || |||| || ||  |||| |||||  |||\+++--+---++-/  |      | |  /+++-+++++-+--+---+\||  ||| ||||||  |/+++++--+-----+-+-++-+++-++++-+++-+\|   || | || 
|| |   || |||| \+-++--++++-+++++--+++-+++--+---++----+------+-+--++++-+++++-+--+---++++--+++-++++++--/|||\++--+-----+-+-++-+++-/|\+-+++-+++---++-/ || 
|| |   |\-++++--+-++--++++-+++++--+++-+++--+---++----+------+-+--++++-++++/ |  |   ||||  ||| ||||||   ||| ||  |     | | || |||  | | ||| |||   ||   || 
|| |   |  ||||  | || /++++-+++++--+++-+++--+---++----+-----\| |  |||| ||||  |  |   ||||  ||| ||||\+---+++-++--+-----+-+-++-+++--+-+-+++-+++---+/   || 
|| |   |  ||||  | || ||||| |||||  ||| |||  |   ||    |     || |  |||| ||||  |  |  /++++--+++-++++-+---+++-++--+-----+-+-++-+++--+-+-+++-+++---+----++\
|| |   |  ||||  | || |||\+-+++++--+++-+++--/   ||    |     |\-+--++++-++++--+--+--+++++--+++-++++-+---+++-++--+-----+-+-/| |||  | | ||| |||   |    |||
|| |   |  ||||  | || ||| | |||||  ||| |||      ||    |     |  |  |||| ||||  |  |  |||||  ||| |||| |   ||| ||  |     | |  | |||  | | ||| |||   |    |||
|| |   |  |||| /+-++-+++-+-+++++--+++-+++------++----+-----+--+--++++-++++--+--+--+++++--+++-++++-+---+++-++--+-----+-+\ | |||  | | ||| |||   |    |||
|| |   |  |||| || \+-+++-+-+++++--+++-+++------++----+-----+--+--++++-++++--+--+--+++++--++/ |||| |   ||| ||  |     | || | |||  | | ||| |||   |    |||
|| |   |  |||| ||  | ||| | |||||  ||| |||   /--++----+-----+--+--++++-++++--+--+--+++++--++--++++-+---+++-++--+-----+-++-+-+++--+\| ||| |||   |    |||
|| |   |  |||| ||  | ||| | |||||  ||| |||   |  ||    |     |  |  |||| ||||  |  |  |||||  ||  |||| |   ||| ||  |     | || | |||  ||| ||| |||   |    |||
|| |   |  |||| ||  | ||| | |||||  |\+-+++---+--++----+-----+--+--++++-++++--+--+--+++++--++--++++-+---+++-++--+-----+-++-+-+++--+++-+++-/||   |    |||
|| |   |  |||| ||  | ||| | |||||  | | |||   |  ||    |     |  \--++++-++++--+--+--+++++--++--++++-+---+++-++--+-----+-++-+-+++--/|| |||  ||   |    |||
|| | /-+--++++-++--+-+++-+-+++++-\| | |||   |  ||    |     |   /-++++-++++--+--+--+++++--++--++++-+---+++-++--+----\| || | |||   || |||  ||   |    |||
|| | | |  ||\+-++--+-+++-+-+++++-++-+-+++---+--++----+-----+---+-++++-++++--+--+--+++++--++--++++-+---+/| ||  |    || || | |||   || |||  ||   |    |||
|| | | |  || | ||  | ||| | ||||| || | ||\---+--++----+-----+---+-++++-++++--+--+--+++++--++--++++-+---+-+-++--/    || || | |||   || |||  ||   |    |||
|| | | |  || | ||  | ||| | ||||| || | ||    |  ||    |     |   | |||| ||||  |  |  |||||  ||  |||| |   | | ||       || || | |||   || |||  ||   |    |||
|| | | |  || | ||  | ||| | ||||| || | ||    |  ||    |     |   | |||| ||\+--+--+--+++++--++--++++-+---+-+-++-------++-++-+-/||   || |||  ||   |    |||
|| | | |  || | ||  | \++-+-+++++-++-+-++----+--++----+-----/   | |||| || |  |  |  |||||/-++--++++-+---+-+-++-------++-++-+--++---++-+++--++--\|    |||
|| | | |  || | ||/-+--++-+-+++++-++-+-++----+--++----+\        | |||| || |  | /+--++++++-++--++++-+---+-+-++-------++-++-+--++---++-+++--++--++--\ |||
|| | | |  || | ||| |  || | ||||| || | ||    |  ||    ||        | |||| || |  | ||  |||||| ||  |||| |   | | ||       || || |  ||   || |||  ||  ||  | |||
|| | | |  || | ||| |  || | ||||| || | ||    |  ||    ||        | \+++-++-+--+-++--++/||| ||  |||| |   | | |\-------++-++-+--++---++-+++--+/  ||  | |||
|| | | |  || | ||| |  || | ||||| || | ||    | /++----++--------+--+++-++-+\ | ||  || ||| ||  |||| | /-+-+-+--------++-++-+--++\  || |||  |   ||  | |||
|| | | |  || | ||| |  || | |||||/++-+-++----+-+++----++-----\  |  ||| || || | ||  || ||| ||  |||\-+-+-+-+-+--------++-++-+--+++--++<+++--+---++--+-+/|
|| | | |  || | ||| |  || | |||||||| | ||    | |||    ||     |  |  ||| || || | ||  || |\+-++--+++--+-+-+-+-+--------++-++-+--/||  || |||  |   ||  | | |
|| | | |  || | ||| |  || \-++++++++-+-++----+-+++----++-----+--+--++/ || || | ||  || | | ||  |||  | | | | |   /----++-++-+---++--++-+++--+---++--+-+\|
|| | | |  || | ||| |  ||   |\++++++-+-++----+-+++----++-----+--+--++--++-++-+-++--++-+-+-++--+++--+-+-+-/ |   |    || || |   ||  || |||  |   ||  | |||
|| | | |  || | ||| |  ||   | |||||| | ||    | |||    ||     |  |  \+--++-++-+-++--++-+-+-/|  |||  | | |   |   |    || || |   ||  || |||  |   ||  | |||
|| | | | /++-+-+++-+--++---+-++++++-+-++----+\|||    ||     |  |   |  || || | \+--++-+-+--+--+++--+-+-+---+---+----++-++-+---++--++-+++--+---++--/ |||
|| | | | ||| | ||| |  ||   | ||\+++-+-++----+++++----++-----+--+---+--++-++-+--+--++-+-+--+--+++--+-+-+---+---+----++-++-+---++--++-+/|  |   ||    |||
|| | | | ||| | ||| |  |\---+-++-+++-+-/|    |||||    \+-----+--+---+--++-++-+--+--++-+-+--+--+/|  | | |   |   |    || || |   ||  |\-+-+--+---++----/||
|| | | | ||| | ||| |  |    | || ||| |  |    |||||     |     |  |   |  || || |/-+--++-+-+--+--+-+--+-+-+---+--\|    || || |   ||  |  | |  |   ||     ||
|| | \-+-+++-+-+++-+--+----+-++-+/| |  |    |||||     |     |  |   |  || || || |  \+-+-+--+--+-+--+-+-+---+--++----++-++-+---++--+--+-+--+---++-----+/
|| |   | ||| | ||| |  |    | || | | |  |    |||||     |     |  |   |  || || || |   | | |  |  | |  | | |   |  |v    || || |   ||  |  | |  |   ||     | 
|| |   | ||| \-+++-+--+----+-++-+-+-+--+----+++++-----+-----+--+---+--++-++-++-+---+-+-+--+--+-+--+-+-+---/  ||    |\-++-+---/|  |  | |  |   ||     | 
|\-+---+-+++---+++-+--+----/ \+-+-+-+--+----+++++-----+-----+--+---/  || || || |   | | |  |  | |  | | |      ||    |  || |    |  |  | |  |   ||     | 
|  |   | |||   ||| |  |       | | | |  |    |||||     |     |  |      |^ || || |   | | |  |  \-+--+-+-+------++----+--++-+----+--+--+-/  |   ||     | 
|  |   | \++---+++-+--+-------+-+-+-+--+----+/|\+-----+-----+--+------++-++-++-+---+-+-+--+----+--/ | |      ||    |  || |    |  |  |    |   ||     | 
|  |   |  ||   ||| |  |       | \-+-+--+----+-+-+-----+-----/  |      |\-++-++-+---+-+-+--+----+----+-+------++----+--++-/    |  |  |    |   ||     | 
|  |   \--++---+++-+--+-------+---+-/  |    | | |     |        |      |  || || |   | | |  \----+----+-+------++----+--++------+--+--+----+---+/     | 
|  |      ||   ||| |  \-------+---+----+----+-+-+-----+--------+------/  || || |   | | |       |    \-+------++----+--++------/  |  |    |   |      | 
|  |      ||   ||\-+----------+---+----+----+-+-+-----/        |         || || |   | | |       |      |      |\----+--++---------+--+----+---+------/ 
|  |      ||   ||  |          |   \----+----+-+-+--------------+---------/| || |   | | |       |      |      |     |  ||         |  |    |   |        
|  \------++---++--+----------+--------+----+-+-+--------------+----------+-++-+---+-/ |       |      |      |     |  ||         |  |    |   |        
|         |\---++--+----------+--------+----+-+-+--------------+----------+-++-+---+---+-------+------+------+-----+--/|         |  |    |   |        
|         |    ||  |          |        |    | | |              |          | || |   |   |       |      |      |     |   |         |  |    |   |        
|         |    ||  |          |        |    | | |              |          | |\-+---+---+-------+------+------/     |   |         |  |    |   |        
\---------+----++--+----------+--------/    \-+-+--------------+----------+-+--+---+---+-------+------+------------+---+---------/  |    |   |        
          |    |\--+----------+---------------+-/              |          | \--+---+---+-------+------+------------+---+------------/    |   |        
          |    |   |          |               \----------------+----------/    |   |   |       |      |            |   |                 |   |        
          \----+---+----------+--------------------------------+---------------+---/   |       |      |            |   |                 |   |        
               |   |          |                                \---------------+-------+-------+------+------------/   |                 |   |        
               |   |          \------------------------------------------------/       \-------+------+----------------+-----------------+---/        
               \---+---------------------------------------------------------------------------+------+----------------/                 |            
                   \---------------------------------------------------------------------------/      \----------------------------------/            