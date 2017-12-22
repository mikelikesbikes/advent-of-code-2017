require "rspec"
require "set"

class SporificaVirus
  attr_reader :cluster, :burst_count, :infections_caused
  attr_accessor :current_node

  def initialize(cluster)
    @cluster = populate_cluster(cluster)
    @current_node = [0, 0]
    @direction = 0
    @burst_count = 0
    @infections_caused = 0
  end

  def burst
    turn
    work
    move
    @burst_count += 1
    self
  end

  def turn
    case state(current_node)
    when :infected then @direction += 1
    when :clean    then @direction -= 1
    end
  end

  def work
    case state(current_node)
    when :infected then clean
    when :clean    then infect
    end
  end

  def move
    x, y = current_node
    case direction
    when :right then self.current_node = [x + 1, y]
    when :left  then self.current_node = [x - 1, y]
    when :up    then self.current_node = [x, y + 1]
    when :down  then self.current_node = [x, y - 1]
    end
  end

  def infect
    @infections_caused += 1
    cluster.store(current_node, :infected)
  end

  def clean
    cluster.delete(current_node)
  end

  DIRECTIONS = [:up, :right, :down, :left]
  def direction
    DIRECTIONS[@direction % 4]
  end

  def state(pos)
    cluster.fetch(pos, :clean)
  end

  private

  INFECTED_MARKER = "#".freeze
  # parse the given cluster input string into a hash of infected cells
  #
  # For example:
  #
  # populate_cluster(<<~CLUSTER)
  #   ..#
  #   #..
  #   ...
  # CLUSTER
  #
  # would return:
  # {[-1, 0] => :infected, [1, 1] => :infected}
  #
  def populate_cluster(cluster)
    cluster = cluster.split(/\n/).map(&:chars)
    midx = cluster.first.length / 2
    midy = cluster.length / 2

    cluster.each_with_object({}).with_index do |(row, cluster), y|
      row.each_with_index do |cell, x|
        # create the code adjusting x and y based on the center of the given
        # cluster being [0, 0]
        node = [x - midx, midy - y]

        # store the node only if it's infected
        cluster.store(node, :infected) if cell == INFECTED_MARKER
      end
    end
  end
end

describe SporificaVirus do
  let(:virus) do
    SporificaVirus.new(<<~CLUSTER)
      ..#
      #..
      ...
    CLUSTER
  end

  specify "the example puzzle" do
    expect(virus.current_node).to eq [0, 0]
    expect(virus.direction).to eq :up

    virus.burst
    expect(virus.state([0, 0])).to be :infected
    expect(virus.direction).to eq :left
    expect(virus.current_node).to eq [-1, 0]

    virus.burst
    expect(virus.state([-1, 0])).to be :clean
    expect(virus.direction).to eq :up
    expect(virus.current_node).to eq [-1, 1]

    4.times { virus.burst }
    expect(virus.state([-1, 0])).to be :infected
    expect(virus.state([-2, 0])).to be :infected
    expect(virus.state([-2, 1])).to be :infected
    expect(virus.state([-1, 1])).to be :infected
    expect(virus.direction).to eq :up
    expect(virus.current_node).to eq [-1, 1]

    virus.burst
    expect(virus.state([-1, 1])).to be :clean
    expect(virus.direction).to eq :right
    expect(virus.current_node).to eq [0, 1]

    expect(virus.burst_count).to eq 7
    expect(virus.infections_caused).to eq 5

    virus.burst until virus.burst_count == 70
    expect(virus.infections_caused).to eq 41
  end

  specify "10_000 times", slow: true do
    virus.burst until virus.burst_count == 10_000
    expect(virus.infections_caused).to eq 5587
  end
end

class SporificaVirusDeux < SporificaVirus
  def turn
    case state(current_node)
    when :infected then @direction += 1
    when :clean    then @direction -= 1
    when :flagged  then @direction += 2
    end
  end

  def work
    case state(current_node)
    when :clean    then weaken
    when :weakened then infect
    when :infected then flag
    when :flagged  then clean
    end
  end

  def weaken
    cluster.store(current_node, :weakened)
  end

  def flag
    cluster.store(current_node, :flagged)
  end
end

describe SporificaVirusDeux do
  let(:virus) do
    described_class.new(<<~CLUSTER)
      ..#
      #..
      ...
    CLUSTER
  end

  specify "the example scenario" do
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

    virus.burst until virus.burst_count == 100
    expect(virus.infections_caused).to eq 26
  end

  specify "10_000_000 times", slow: true do
    virus.burst until virus.burst_count == 10_000_000
    expect(virus.infections_caused).to eq 2_511_944
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

virus.burst until virus.burst_count == 10_000
puts virus.infections_caused

# Part 2
evolved_virus = SporificaVirusDeux.new(cluster)

evolved_virus.burst until evolved_virus.burst_count == 10_000_000
puts evolved_virus.infections_caused
