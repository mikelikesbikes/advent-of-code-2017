require "rspec"
class Spinlock
  attr_reader :step_size, :pos, :value, :length

  def initialize(step_size:)
    @step_size = step_size
    @pos = 0
    @value = 0
    @length = 1
  end

  def next(&block)
    @pos = ((pos + step_size) % @length) + 1
    @value += 1
    @length += 1
    [pos, value]
  end
end
describe Spinlock do
  let(:spinlock) { described_class.new(step_size: 3) }

  describe "next" do
    specify "returns position and value" do
      expect(spinlock.next).to eq [1, 1]
      expect(spinlock.next).to eq [1, 2]
      expect(spinlock.next).to eq [2, 3]
      expect(spinlock.next).to eq [2, 4]
      expect(spinlock.next).to eq [1, 5]
      expect(spinlock.next).to eq [5, 6]
      expect(spinlock.next).to eq [2, 7]
      expect(spinlock.next).to eq [6, 8]
      expect(spinlock.next).to eq [1, 9]
    end
  end
end

return if /rspec$/ === $PROGRAM_NAME

STEP_SIZE = 329

# Part 1
spinlock = Spinlock.new(step_size: STEP_SIZE)
array = [0]
2017.times do
  array.insert(*spinlock.next)
end
puts array[spinlock.pos + 1]

# Part 2
spinlock = Spinlock.new(step_size: STEP_SIZE)

last_value = nil
50_000_000.times do
  pos, value = spinlock.next
  last_value = value if pos == 1
end
puts last_value
