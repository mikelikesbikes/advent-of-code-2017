require "rspec"

class FractalArt
  attr_reader :fractal, :enhancement_rules

  def initialize(enhancement_rules)
    @enhancement_rules = parse_rules(enhancement_rules)
    @fractal = <<~FRACTAL.split(/\n/).map(&:chars)
      .#.
      ..#
      ###
    FRACTAL
  end

  def enhance
    if fractal.length < 4
      @fractal = find_enhancement(fractal)
    else
      square_size = fractal.length % 2 == 0 ? 2 : 3
      @fractal = compose_squares(
        divide_squares(fractal, square_size).map { |square| find_enhancement(square) }
      )
    end
  end

  def to_s
    fractal.map(&:join).join("\n")
  end

  def on_count
    fractal.flatten.count { |c| c == "#" }
  end

  private

  def parse_rules(input)
    input.split(/\n/).each_with_object({}) do |rule, rules|
      pattern, fractal = rule.split("=>").map { |part| part.strip.split(/\//).map(&:chars) }
      4.times do
        rules.store(keyify(pattern), fractal)
        pattern = rotate(pattern)
      end
      pattern = flip(pattern)
      4.times do
        rules.store(keyify(pattern), fractal)
        pattern = rotate(pattern)
      end
    end
  end

  def rotate(pattern)
    pattern.transpose.map(&:reverse)
  end

  def flip(pattern)
    pattern.reverse
  end

  def divide_squares(fractal, size)
    fractal.each_slice(size).each_with_object([]) do |rows, squares|
      first, *rest = rows.map { |row| row.each_slice(size) }
      squares.concat(first.zip(*rest))
    end
  end

  def compose_squares(squares)
    square_width = Math.sqrt(squares.length)
    row_width = Math.sqrt(squares.flatten.length)
    squares.each_slice(square_width).map { |first, *rest| first.zip(*rest) }.flatten.each_slice(row_width).to_a
  end

  def find_enhancement(square)
    enhancement_rules.fetch(keyify(square))
  end

  def keyify(square)
    square.map(&:join).join("/")
  end
end

describe FractalArt do
  specify "the example" do
    enhancement_rules = <<~RULES
      ../.# => ##./#../...
      .#./..#/### => #..#/..../..../#..#
    RULES

    art = FractalArt.new(enhancement_rules)
    expect(art.to_s).to eq <<~FRACTAL.strip
      .#.
      ..#
      ###
    FRACTAL

    expect { art.enhance }.to change { art.to_s }.to <<~FRACTAL.strip
      #..#
      ....
      ....
      #..#
    FRACTAL

    expect { art.enhance }.to change { art.to_s }.to <<~FRACTAL.strip
      ##.##.
      #..#..
      ......
      ##.##.
      #..#..
      ......
    FRACTAL

    expect(art.on_count).to eq 12
  end

  specify "flipping" do
    enhancement_rules = <<~RULES
      .#./#../### => #..#/..../..../#..#
      .#./#../### => #..#/..../..../#..#
    RULES

    art = FractalArt.new(enhancement_rules)
    expect { art.enhance }.to change { art.to_s }.to <<~FRACTAL.strip
      #..#
      ....
      ....
      #..#
    FRACTAL
  end
end

enhancement_rules = <<~RULES
../.. => .##/.##/###
#./.. => .../#.#/###
##/.. => .##/.../.#.
.#/#. => ###/.#./##.
##/#. => .#./#../#.#
##/## => .##/#.#/###
.../.../... => ####/.##./####/.#..
#../.../... => ..../..##/#.../.##.
.#./.../... => #.#./##.#/#.../#.#.
##./.../... => .#../.##./#.../....
#.#/.../... => ###./..##/..##/##.#
###/.../... => .###/#.##/..../....
.#./#../... => ##.#/#..#/.##./...#
##./#../... => ..../#..#/#.#./...#
..#/#../... => #.##/.#../.#.#/###.
#.#/#../... => ##../.#.#/...#/...#
.##/#../... => ##.#/.##./..#./##.#
###/#../... => ...#/####/..#./#...
.../.#./... => ##.#/#.#./..##/.##.
#../.#./... => .#.#/#.##/.##./....
.#./.#./... => #..#/#.../.##./....
##./.#./... => ###./###./..##/#..#
#.#/.#./... => .###/...#/###./###.
###/.#./... => ...#/..##/..#./#.##
.#./##./... => .##./.#../...#/..#.
##./##./... => .###/..#./.###/###.
..#/##./... => .#.#/..#./..#./...#
#.#/##./... => .#.#/##../#.../.##.
.##/##./... => .##./...#/#.##/###.
###/##./... => ...#/###./####/#.##
.../#.#/... => #.#./#.../#.#./..#.
#../#.#/... => ###./##../..#./.#..
.#./#.#/... => #.../..##/#..#/#.#.
##./#.#/... => #.#./.##./#..#/##.#
#.#/#.#/... => #.##/.#.#/#..#/.#.#
###/#.#/... => #.../##.#/###./....
.../###/... => ..##/...#/##.#/###.
#../###/... => .#.#/...#/#.##/.#..
.#./###/... => ####/#.../..#./.#.#
##./###/... => ..../####/#.##/#..#
#.#/###/... => ####/..#./####/.#.#
###/###/... => ..##/..../...#/.#..
..#/.../#.. => .###/..##/.#.#/.##.
#.#/.../#.. => #.##/#..#/.#.#/##.#
.##/.../#.. => #.##/####/.#.#/..#.
###/.../#.. => ##../##.#/..../##..
.##/#../#.. => ...#/####/..##/.##.
###/#../#.. => ..#./...#/#.../##.#
..#/.#./#.. => #..#/##.#/..##/#..#
#.#/.#./#.. => ..../.###/#..#/..##
.##/.#./#.. => ..#./...#/..##/...#
###/.#./#.. => ...#/..../##.#/....
.##/##./#.. => .#../..##/...#/.#.#
###/##./#.. => .###/#.#./####/#.#.
#../..#/#.. => .###/##.#/##../##..
.#./..#/#.. => ##../.#../###./##.#
##./..#/#.. => #..#/####/####/..##
#.#/..#/#.. => ..##/..../###./..##
.##/..#/#.. => ..##/.#.#/.#../.#..
###/..#/#.. => ...#/.###/.###/.#.#
#../#.#/#.. => ##../##../##.#/.##.
.#./#.#/#.. => ...#/.##./.#.#/#...
##./#.#/#.. => .##./.#../.#../#...
..#/#.#/#.. => ..##/##.#/####/###.
#.#/#.#/#.. => ..../.###/#.../#..#
.##/#.#/#.. => ..#./#.#./.#../...#
###/#.#/#.. => ##.#/#.../##.#/.##.
#../.##/#.. => ..../#.../..#./####
.#./.##/#.. => #..#/.#../#.#./..##
##./.##/#.. => .###/..##/###./....
#.#/.##/#.. => .###/.##./.###/#.##
.##/.##/#.. => #.##/###./.##./...#
###/.##/#.. => ...#/#.##/.##./#.#.
#../###/#.. => #..#/.###/.###/#.#.
.#./###/#.. => ..#./#.#./..../...#
##./###/#.. => ..##/##../#..#/....
..#/###/#.. => ..##/.#../.#../###.
#.#/###/#.. => ..#./.###/..../...#
.##/###/#.. => .##./###./#.../#.##
###/###/#.. => ##.#/..../.##./##.#
.#./#.#/.#. => .##./.#.#/####/....
##./#.#/.#. => ##.#/#.##/####/.#..
#.#/#.#/.#. => ####/.##./##.#/...#
###/#.#/.#. => #..#/#.##/.##./###.
.#./###/.#. => .#../..../.##./##.#
##./###/.#. => ##.#/.#../#.../.###
#.#/###/.#. => ###./###./.#../###.
###/###/.#. => #..#/#.../#..#/.#.#
#.#/..#/##. => #..#/#.../##../###.
###/..#/##. => #.../.#../.###/#...
.##/#.#/##. => .#.#/.##./.#../##.#
###/#.#/##. => #.../..../##../.###
#.#/.##/##. => .#.#/##../.###/#.#.
###/.##/##. => ###./..#./##.#/.###
.##/###/##. => ..#./.#.#/##.#/#.#.
###/###/##. => ##../.#.#/#..#/.#.#
#.#/.../#.# => ##../###./..#./##.#
###/.../#.# => .#../##../..#./##.#
###/#../#.# => ###./#..#/####/....
#.#/.#./#.# => .###/..../.###/##.#
###/.#./#.# => ###./.###/..##/.#.#
###/##./#.# => ..#./..##/#..#/#.##
#.#/#.#/#.# => .#.#/.#../.#.#/#.##
###/#.#/#.# => .###/#.../##../.###
#.#/###/#.# => .#../...#/..../...#
###/###/#.# => #..#/##.#/..#./#...
###/#.#/### => .###/.#.#/..#./####
###/###/### => ##.#/..##/.#../..##
RULES

return if /rspec$/ === $PROGRAM_NAME

# Part 1
art = FractalArt.new(enhancement_rules)
5.times { art.enhance }
puts art.on_count

# Part 2
art = FractalArt.new(enhancement_rules)
18.times { art.enhance }
puts art.on_count
