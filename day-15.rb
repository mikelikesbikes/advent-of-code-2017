require "rspec"

class Generator
  DIVISOR = 2147483647

  attr_reader :factor, :previous_value, :constraint

  def initialize(previous_value:, factor:, constraint: nil)
    @previous_value = previous_value
    @factor = factor
    @constraint = constraint
  end

  def next
    loop do
      self.previous_value = (previous_value * factor) % DIVISOR
      return previous_value if !constraint || constraint.call(previous_value)
    end
  end

  private
  attr_writer :previous_value
end

describe Generator do
  describe "next" do
    specify "produces the next factor" do
      generator_a = Generator.new(factor: 16807, previous_value: 65)
      expect(generator_a.next).to eq    1092455
      expect(generator_a.next).to eq 1181022009
      expect(generator_a.next).to eq  245556042
      expect(generator_a.next).to eq 1744312007
      expect(generator_a.next).to eq 1352636452

      generator_b = Generator.new(factor: 48271, previous_value: 8921)
      expect(generator_b.next).to eq  430625591
      expect(generator_b.next).to eq 1233683848
      expect(generator_b.next).to eq 1431495498
      expect(generator_b.next).to eq  137874439
      expect(generator_b.next).to eq  285222916
    end

    context "with constraint" do
      specify "produces the next factor" do
        generator_a = Generator.new(factor: 16807, previous_value: 65, constraint: ->(i) { i % 4 == 0 })
        expect(generator_a.next).to eq 1352636452
        expect(generator_a.next).to eq 1992081072
        expect(generator_a.next).to eq  530830436
        expect(generator_a.next).to eq 1980017072
        expect(generator_a.next).to eq  740335192

        generator_b = Generator.new(factor: 48271, previous_value: 8921, constraint: ->(i) { i % 8 == 0 })
        expect(generator_b.next).to eq 1233683848
        expect(generator_b.next).to eq  862516352
        expect(generator_b.next).to eq 1159784568
        expect(generator_b.next).to eq 1616057672
        expect(generator_b.next).to eq  412269392
      end
    end
  end
end

class Judge
  MASK = "ffff".hex
  def initialize(g1, g2)
    @g1 = g1
    @g2 = g2
  end

  def sample(n)
    n.times.count do |i|
      @g1.next & MASK == @g2.next & MASK
    end
  end
end

describe Judge do
  describe "sample" do
    specify "returns the number of matching pairs" do
      g1 = double(:g1)
      g2 = double(:g2)
      allow(g1).to receive(:next).and_return(1, 2, 3, 4)
      allow(g2).to receive(:next).and_return(0, 2, 1, 4)

      judge = Judge.new(g1, g2)
      expect(judge.sample(3)).to eq 1
    end
  end
end

return if /rspec$/ === $PROGRAM_NAME

# Part 1
generator_a = Generator.new(factor: 16807, previous_value: 634)
generator_b = Generator.new(factor: 48271, previous_value: 301)
judge = Judge.new(generator_a, generator_b)
puts judge.sample(40_000_000)

# Part 2
generator_a = Generator.new(factor: 16807, previous_value: 634, constraint: ->(i) { i >> 2 << 2 == i })
generator_b = Generator.new(factor: 48271, previous_value: 301, constraint: ->(i) { i >> 3 << 3 == i })
judge = Judge.new(generator_a, generator_b)
puts judge.sample(5_000_000)
