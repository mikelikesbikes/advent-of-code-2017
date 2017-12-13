width = 605
shift = (width - 1)/2
grid = Array.new(width) { Array.new(width, nil) }

cell = Cell.new
x, y = cell.coord
grid[x + shift][y + shift] = 1

(2..605**2).each do |i|
  x, y = cell.next
  grid[y + shift][x + shift] = val = cell.adjacents.map { |gx, gy| grid[gy + shift][gx + shift] }.compact.sum
  if val > 368078
    p val
    exit
  end
end
puts grid.map{ |row| row.map { |i| i.to_s.ljust(4, " ") }.join(" ") }.join("\n")

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
      @y -= 1
      @dir += 1 if -y == @layer
    when 2
      @x -= 1
      @dir += 1 if -x == @layer
    when 3
      @y += 1
      if y == @layer
        @dir = 0
        @layer += 1
      end
    end
    [x, y]
  end

  def coord
    [x, y]
  end

  def adjacents
    [[x + 1, y], [x + 1, y + 1], [x + 1, y - 1], [x - 1, y], [x - 1, y + 1], [x - 1, y - 1], [x, y + 1], [x, y - 1]]
  end
end
