require 'matrix'
require 'set'
require 'tsort'

Point =
  Struct.new(:x, :y) do
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

    def <=>(other)
      [x, y] <=> [other.x, other.y]
    end

    def to_s
      "(#{x}, #{y})"
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

    def non_diag_neighbors(
      distance,
      min_x: nil,
      min_y: nil,
      max_x: nil,
      max_y: nil
    )
      [-1, 0, 1].flat_map do |dx|
        [-1, 0, 1].map do |dy|
          next if dx.zero? && dy.zero?
          next if dx.nonzero? && dy.nonzero?

          x_ = x + dx * distance
          y_ = y + dy * distance

          next if (min_x && x_ < min_x) || (max_x && x_ > max_x)
          next if (min_y && y_ < min_y) || (max_y && y_ > max_y)

          self.class.new(x_, y_)
        end.compact
      end
    end
  end

class Array
  def median
    mid = length / 2
    sorted = sort
    length.odd? ? sorted[mid] : (sorted[mid] + sorted[mid - 1]) / 2
  end

  def mean
    sum / count
  end

  def only
    raise "#{self}.length != 1" unless length == 1
    first
  end
end
