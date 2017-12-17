require "rspec"
class Spinlock
  attr_reader :seed, :pos, :array, :length
  alias_method :to_a, :array

  def initialize(seed:)
    @seed = seed
    @array = [0]
    @pos = 0
    @next_value = 1
    @length = 1
  end

  def next(&block)
    @pos = ((pos + seed) % @length) + 1
    if block_given?
      block.call(pos, next_value)
    else
      array.insert(pos, next_value)
    end
    @length += 1
    @next_value += 1
    self
  end

  private
  attr_reader :next_value
end
describe Spinlock do
  let(:spinlock) { described_class.new(seed: 3) }

  specify "starts with a single element, value of 0" do
    expect(spinlock.to_a).to eq [0]
  end

  describe "next" do
    specify "inserts values" do
      expect(spinlock.next.to_a).to eq [0, 1]
      expect(spinlock.next.to_a).to eq [0, 2, 1]
      expect(spinlock.next.to_a).to eq [0, 2, 3, 1]
      expect(spinlock.next.to_a).to eq [0, 2, 4, 3, 1]
      expect(spinlock.next.to_a).to eq [0, 5, 2, 4, 3, 1]
      expect(spinlock.next.to_a).to eq [0, 5, 2, 4, 3, 6, 1]
      expect(spinlock.next.to_a).to eq [0, 5, 7, 2, 4, 3, 6, 1]
      expect(spinlock.next.to_a).to eq [0, 5, 7, 2, 4, 3, 8, 6, 1]
      expect(spinlock.next.to_a).to eq [0, 9, 5, 7, 2, 4, 3, 8, 6, 1]
    end
  end
end

# Part 1
spinlock = Spinlock.new(seed: 329)
2017.times { spinlock.next }
puts spinlock.array[spinlock.pos + 1]

# Part 2
spinlock = Spinlock.new(seed: 329)

last_value = nil
50_000_000.times do |i|
  spinlock.next do |pos, value|
    last_value = value if pos == 1
  end
end

puts last_value
