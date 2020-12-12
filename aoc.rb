require 'set'
require 'tsort'

Point = Struct.new(:x, :y) do
  def +(other)
    self.class.new(x + other.x, y + other.y)
  end

  def -(other)
    self.class.new(x - other.x, y - other.y)
  end

  def rotated_deg(deg)
    r = to_c * Math::E.to_c**(1i * deg * Math::PI / 180)
    self.class.new(r.real, r.imag)
  end

  def to_c
    x + y * 1i
  end

  def up(dy)
    self.class.new(x, y + dy)
  end

  def right(dx)
    self.class.new(x + dx)
  end

  def neighbors(distance, min_x: nil, min_y: nil, max_x: nil, max_y: nil)
    [-1, 0, 1].flat_map do |dx|
      [-1, 0, 1].map do |dy|
        next if dx.zero? && dy.zero?

        x_ = x + dx * distance
        y_ = y + dy * distance

        next if (min_x && x_ < min_x) || (max_x && x_ > max_x)
        next if (min_y && y_ < min_y) || (max_y && y_ > max_y)

        self.class.new(x_, y_)
      end.compact
    end
  end
end
