class KnotHash
  attr_reader :list, :position, :skip_size

  def initialize(list = [*0..255])
    @list = list
    @position = 0
    @skip_size = 0
  end

  def self.hash(input)
    hasher = self.new
    lengths = input.chars.map(&:ord) + [17, 31, 73, 47, 23]
    64.times { hasher.step(*lengths) }
    sparse_hash = hasher.list
    dense_hash = sparse_hash.each_slice(16).map { |slice| slice.reduce(&:^) }
    dense_hash.map { |i| "%02x" % i }.join
  end

  def step(*lengths)
    lengths.each do |length|
      reverse_list(length)
      advance_position(length)
      increment_skip_size
    end
  end

  private

  def reverse_list(length)
    list.rotate!(position)
    slice = list.slice!(0, length)
    list.insert(0, *slice.reverse)
    list.rotate!(-position)
  end

  def advance_position(length)
    @position = (@position + length + skip_size) % list.length
  end

  def increment_skip_size
    @skip_size += 1
  end
end

require 'rspec'
describe KnotHash do
  let(:list) { [0, 1, 2, 3, 4] }

  subject { described_class.new(list) }

  describe "single step" do
    let(:length) { 3 }
    it "reverses elements" do
      expect {
        subject.step(length)
      }.to change { subject.list }.to [2, 1, 0, 3, 4]
    end

    it "sets current position" do
      expect {
        subject.step(length)
      }.to change { subject.position }.from(0).to(3)
    end

    it "increments skip_size" do
      expect {
        subject.step(length)
      }.to change { subject.skip_size }.from(0).to(1)
    end
  end

  describe "multiple steps" do
    let(:lengths) { [3, 4, 1, 5] }

    it "reverses elements" do
      expect {
        subject.step(*lengths)
      }.to change { subject.list }.to [3, 4, 2, 1, 0]
    end

    it "sets current position" do
      expect {
        subject.step(*lengths)
      }.to change { subject.position }.from(0).to(4)
    end

    it "increments skip_size" do
      expect {
        subject.step(*lengths)
      }.to change { subject.skip_size }.from(0).to(4)
    end
  end

  describe "::hash" do
    specify "The empty string becomes a2582a3a0e66e6e86e3812dcb672a272" do
      expect(KnotHash.hash("")).to eq "a2582a3a0e66e6e86e3812dcb672a272"
    end

    specify "\"AoC 2017\" becomes 33efeb34ea91902bb2f59c9920caa6cd" do
      expect(KnotHash.hash("AoC 2017")).to eq "33efeb34ea91902bb2f59c9920caa6cd"
    end

    specify "\"1,2,3\" becomes 3efbe78a8d82f29979031a4aa0b16a9d" do
      expect(KnotHash.hash("1,2,3")).to eq "3efbe78a8d82f29979031a4aa0b16a9d"
    end

    specify "\"1,2,4\" becomes 63960835bcdc130f0b66d7ff4f6a5a8e" do
      expect(KnotHash.hash("1,2,4")).to eq "63960835bcdc130f0b66d7ff4f6a5a8e"
    end
  end
end

## Part 1

part_1_lengths = [120,93,0,90,5,80,129,74,1,165,204,255,254,2,50,113]

part_1 = KnotHash.new
part_1.step(*part_1_lengths)

a, b = part_1.list
puts a * b

## Part 2
puts part_2 = KnotHash.hash(part_1_lengths.join(","))
