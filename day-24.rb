require "rspec"
require "set"

class ElectomagneticMoat
  attr_reader :connectors, :bridges

  def initialize(connectors)
    @connectors = connectors.map { |c| c.split("/").map(&:to_i) }
    build_bridges
  end

  private

  def n_pin_connectors(n)
    connectors.select { |connector| connector.any? { |port| port == n } }
  end

  def build_bridges
    @bridges = []
    bridges_to_extend = []

    n_pin_connectors(0).each do |connector|
      bridge = Bridge.new(connector)
      @bridges << bridge
      bridges_to_extend << bridge
    end

    while !bridges_to_extend.empty?
      bridge = bridges_to_extend.shift
      available_connectors = n_pin_connectors(bridge.end_port) - bridge.connectors
      available_connectors.each do |connector|
        new_bridge = Bridge.new(*bridge.connectors, connector)
        @bridges << new_bridge
        bridges_to_extend << new_bridge
      end
    end
  end
end

class Bridge
  attr_reader :connectors

  def initialize(*connectors)
    @connectors = connectors
  end

  def strength
    connectors.flatten.sum
  end

  def start_port
    0
  end

  def end_port
    previous_end = 0
    i = 0
    while i < connectors.length
      a, b = connectors[i]
      previous_end = previous_end == a ? b : a
      i += 1
    end
    previous_end
  end
end

describe ElectomagneticMoat do
  let(:moat) do
    described_class.new(<<~CONNECTORS.split(/\n/))
      0/2
      2/2
      2/3
      3/4
      3/5
      0/1
      10/1
      9/10
    CONNECTORS
  end

  specify "the example" do
    expect(moat.bridges.map(&:connectors).to_set).to eq \
      <<~BRIDGES.split(/\n/).map { |line| line.split("--").map { |c| c.split(/\//).map(&:to_i) } }.to_set
        0/1
        0/1--10/1
        0/1--10/1--9/10
        0/2
        0/2--2/3
        0/2--2/3--3/4
        0/2--2/3--3/5
        0/2--2/2
        0/2--2/2--2/3
        0/2--2/2--2/3--3/4
        0/2--2/2--2/3--3/5
      BRIDGES

    bridge = moat.bridges.max_by(&:strength)
    expect(bridge.connectors).to eq [[0, 1], [10, 1], [9, 10]]
    expect(bridge.strength).to eq 31
  end
end

describe Bridge do
  let(:bridge) { Bridge.new([0, 1], [10, 1], [9, 10]) }

  specify "start_port returns 0" do
    expect(bridge.start_port).to eq 0
  end

  specify "end_port returns 9" do
    expect(bridge.end_port).to eq 9
  end

  specify "strength" do
    expect(bridge.strength).to eq 31
  end
end

connectors = <<-CONNECTORS.split(/\n/)
14/42
2/3
6/44
4/10
23/49
35/39
46/46
5/29
13/20
33/9
24/50
0/30
9/10
41/44
35/50
44/50
5/11
21/24
7/39
46/31
38/38
22/26
8/9
16/4
23/39
26/5
40/40
29/29
5/20
3/32
42/11
16/14
27/49
36/20
18/39
49/41
16/6
24/46
44/48
36/4
6/6
13/6
42/12
29/41
39/39
9/3
30/2
25/20
15/6
15/23
28/40
8/7
26/23
48/10
28/28
2/13
48/14
CONNECTORS

moat = ElectomagneticMoat.new(connectors)

puts moat.bridges.max_by(&:strength).strength

puts moat.bridges.max_by { |bridge| [bridge.connectors.length, bridge.strength] }.strength
