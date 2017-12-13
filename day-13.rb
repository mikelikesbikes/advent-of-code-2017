class Firewall
  attr_reader :caught_levels, :depths, :pico, :delay

  def initialize(depths, delay = 0)
    @depths = depths
    @caught_levels = []
    @pico = @delay = delay
  end

  def tick
    level = packet_level(pico)
    if (range = scanner_range(level)) && scanner_at_top?(range, pico)
      caught_levels << level
    end
    @pico += 1
  end

  def play
    depths.keys.max.succ.times { tick }
  end

  def play!
    depths.keys.max.succ.times do
      tick
      raise "CAUGHT" unless caught_levels.empty?
    end
  end

  def trip_severity
    caught_levels.sum { |level| depths[level] * level }
  end

  def scanner_range(pos)
    depths[pos]
  end

  def packet_level(pico)
    pico - delay
  end

  def scanner_at_top?(range, pico)
    pico % ((range - 1) * 2) == 0
  end
end

require "rspec"
describe Firewall do
  let(:firewall) { described_class.new(depth, delay) }
  let(:depth) do
    {
      0 => 3,
      1 => 2,
      4 => 4,
      6 => 4
    }
  end
  let(:delay) { 0 }

  describe "first tick" do
    specify "caught" do
      firewall.tick
      expect(firewall.caught_levels).to eq [0]
    end

    specify "" do
      expect { firewall.tick }.to change { firewall.pico }.to(1)
    end
  end

  describe "play" do
    specify "caught" do
      expect { firewall.play }.to change{ firewall.caught_levels }.from([]).to([0,6])
    end

    specify "trip severity" do
      firewall.play
      expect(firewall.trip_severity).to eq 24
    end

    specify "raising" do
      expect { firewall.play! }.to raise_error(RuntimeError)
    end

    context "with delay of 10" do
      let(:delay) { 10 }
      specify "not caught" do
        firewall.play
        expect(firewall.caught_levels).to be_empty
      end

      specify "not to raise" do
        expect { firewall.play! }.not_to raise_error
      end
    end
  end
end

depth_chart = Hash[<<-DEPTHCHART.split("\n").map { |s| s.split(": ").map(&:to_i) }]
0: 3
1: 2
2: 4
4: 6
6: 5
8: 8
10: 6
12: 4
14: 8
16: 6
18: 8
20: 8
22: 6
24: 8
26: 9
28: 12
30: 8
32: 14
34: 10
36: 12
38: 12
40: 10
42: 12
44: 12
46: 12
48: 12
50: 14
52: 12
54: 14
56: 12
60: 14
62: 12
64: 14
66: 14
68: 14
70: 14
72: 14
74: 14
78: 26
80: 18
82: 17
86: 18
88: 14
96: 18
DEPTHCHART

# Part 1
firewall = Firewall.new(depth_chart)
firewall.play
puts firewall.trip_severity

# Part 2
delay = 0
loop do
  begin
    firewall = Firewall.new(depth_chart, delay)
    firewall.play!
    break
  rescue => e
    delay += 1
  end
end
puts delay

