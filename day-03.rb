class Cell
  attr_reader :x, :y

  def initialize
    @x = 0
    @y = 0
    @dir = 0
    @layer = 1
  end

  def next
    case @dir
    when 0
      @x += 1
      @dir += 1 if x == @layer
    when 1
      @y += 1
      @dir += 1 if y == @layer
    when 2
      @x -= 1
      @dir += 1 if -x == @layer
    when 3
      @y -= 1
      if -y == @layer
        @dir = 0
        @layer += 1
      end
    end
    self
  end

  def coord
    [x, y]
  end

  def adjacents
    [[x + 1, y], [x + 1, y + 1], [x + 1, y - 1], [x - 1, y], [x - 1, y + 1], [x - 1, y - 1], [x, y + 1], [x, y - 1]]
  end

  def distance(other)
    xo, yo = other.coord
    x, y = coord
    (xo - x).abs + (yo - y).abs
  end
end

# Part 1
n = 368078

origin = Cell.new
cell = Cell.new
(n-1).times { cell.next }

puts cell.distance(origin)

# Part 2
grid = Hash.new { |h, k| h[k] = 0 }
cell = Cell.new
grid[cell.coord] = val = 1

while val <= n
  cell.next
  grid[cell.coord] = val = cell.adjacents.sum { |coord| grid[coord] }
end
puts val

