require 'set'
require 'tsort'

Point = Struct.new(:x, :y) do
    def +(other)
        new(x + other.x, y + other.y)
    end

    def -(other)
        new(x - other.x, y - other.y)
    end
end
