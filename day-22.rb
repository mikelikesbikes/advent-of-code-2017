require "rspec"
require "set"

class SporificaVirus
  attr_reader :current_node, :cluster, :bursts, :infections

  def initialize(cluster)
    @cluster = populate_cluster(cluster.split(/\n/).map(&:chars))
    @current_node = [0, 0]
    @direction = 0
    @bursts = 0
    @infections = 0
  end

  def burst
    turn
    work
    move
    @bursts += 1
    self
  end

  def turn
    if infected?(current_node)
      @direction += 1
    else
      @direction -= 1
    end
  end

  def work
    if infected?(current_node)
      clean
    else
      infect
    end
  end

  def infect
    @infections += 1
    cluster.store(current_node.dup, :infected)
  end

  def clean
    cluster.delete(current_node)
  end

  def move
    case direction
    when :up
      current_node[1] += 1
    when :right
      current_node[0] += 1
    when :down
      current_node[1] -= 1
    when :left
      current_node[0] -= 1
    end
  end

  DIRECTIONS = [:up, :right, :down, :left]
  def direction
    DIRECTIONS[@direction % 4]
  end

  def state(pos)
    cluster.fetch(pos, :clean)
  end

  def infected?(pos)
    state(pos) == :infected
  end

  private

  def populate_cluster(cluster)
    midx = cluster.first.length / 2
    midy = cluster.length / 2
    infected_cells = {}
    cluster.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell == "#"
          infected_cells.store([x - midx, midy - y], :infected)
        end
      end
    end
    infected_cells
  end
end

describe SporificaVirus do
  specify "the example puzzle" do
    cluster = <<~CLUSTER
      ..#
      #..
      ...
    CLUSTER

    virus = SporificaVirus.new(cluster)
    expect(virus.current_node).to eq [0, 0]
    expect(virus.direction).to eq :up

    virus.burst
    expect(virus.infected?([0, 0])).to eq true
    expect(virus.direction).to eq :left
    expect(virus.current_node).to eq [-1, 0]

    virus.burst
    expect(virus.infected?([-1, 0])).to eq false
    expect(virus.direction).to eq :up
    expect(virus.current_node).to eq [-1, 1]

    4.times { virus.burst }
    expect(virus.infected?([-1, 0])).to eq true
    expect(virus.infected?([-2, 0])).to eq true
    expect(virus.infected?([-2, 1])).to eq true
    expect(virus.infected?([-1, 1])).to eq true
    expect(virus.direction).to eq :up
    expect(virus.current_node).to eq [-1, 1]

    virus.burst
    expect(virus.infected?([-1, 1])).to eq false
    expect(virus.direction).to eq :right
    expect(virus.current_node).to eq [0, 1]

    expect(virus.bursts).to eq 7
    expect(virus.infections).to eq 5

    virus.burst until virus.bursts == 70
    expect(virus.infections).to eq 41

    virus.burst until virus.bursts == 10_000
    expect(virus.infections).to eq 5587
  end
end

class SporificaVirusDeux < SporificaVirus
  def turn
    case state(current_node)
    when :infected
      @direction += 1
    when :clean
      @direction -= 1
    when :flagged
      @direction += 2
    end
  end

  def work
    case state(current_node)
    when :clean
      weaken
    when :weakened
      infect
    when :infected
      flag
    when :flagged
      clean
    end
  end

  def weaken
    cluster.store(current_node.dup, :weakened)
  end

  def flag
    cluster.store(current_node.dup, :flagged)
  end
end

describe SporificaVirusDeux do
  specify "the example" do
    cluster = <<~CLUSTER
      ..#
      #..
      ...
    CLUSTER

    virus = described_class.new(cluster)
    expect(virus.current_node).to eq [0, 0]
    expect(virus.direction).to eq :up

    virus.burst
    expect(virus.state([0, 0])).to eq :weakened
    expect(virus.direction).to eq :left
    expect(virus.current_node).to eq [-1, 0]

    virus.burst
    expect(virus.state([-1, 0])).to eq :flagged
    expect(virus.direction).to eq :up
    expect(virus.current_node).to eq [-1, 1]

    3.times { virus.burst }
    expect(virus.current_node).to eq [-1, 0]
    expect(virus.state([-1, 0])).to eq :flagged
    expect(virus.direction).to eq :right

    virus.burst
    expect(virus.current_node).to eq [-2, 0]
    expect(virus.state([-1, 0])).to eq :clean
    expect(virus.direction).to eq :left

    virus.burst
    expect(virus.current_node).to eq [-3, 0]
    expect(virus.state([-2, 0])).to eq :infected
    expect(virus.direction).to eq :left

    virus.burst until virus.bursts == 100
    expect(virus.infections).to eq 26

    virus.burst until virus.bursts == 10_000_000
    expect(virus.infections).to eq 2_511_944
  end
end

return if /rspec$/ === $PROGRAM_NAME

cluster = <<-CLUSTER
.########.....#...##.####
....#..#.#.##.###..#.##..
##.#.#..#.###.####.##.#..
####...#...####...#.##.##
..#...###.#####.....##.##
..#.##.######.#...###...#
.#....###..##....##...##.
##.##..####.#.######...##
#...#..##.....#..#...#..#
........#.##..###.#.....#
#.#..######.#.###..#...#.
.#.##.##..##.####.....##.
.....##..#....#####.#.#..
...#.#.#..####.#..###..#.
##.#..##..##....#####.#..
.#.#..##...#.#####....##.
.####.#.###.####...#####.
...#...######..#.##...#.#
#..######...#.####.#..#.#
...##..##.#.##.#.#.#....#
###..###.#..#.....#.##.##
..#....##...#..#..##..#..
.#.###.##.....#.###.#.###
####.##...#.#....#..##...
#.....#.#..#.##.#..###..#
CLUSTER

# Part 1
virus = SporificaVirus.new(cluster)

virus.burst until virus.bursts == 10_000
puts virus.infections

# Part 2
evolved_virus = SporificaVirusDeux.new(cluster)

evolved_virus.burst until evolved_virus.bursts == 10_000_000
puts evolved_virus.infections
