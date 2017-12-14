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

module Converters
  def hex_to_binary(hexstr)
    hexstr.chars.map { |c| "%04b" % c.hex }.join
  end

  extend self
end

module Graph
  def connected(graph, start_node)
    to_visit = Set.new([start_node])
    visited = Set.new

    while (node = to_visit.first) && to_visit.delete(node)
      visited << node
      to_visit |= (graph[node] - visited)
    end

    visited
  end

  def groups(graph)
    groups = Set.new
    to_visit = Set.new(graph.keys)

    while (node = to_visit.first) && to_visit.delete(node)
      groups << (group = connected(graph, node))
      to_visit -= group
    end

    groups
  end
  extend self
end

require "rspec"
describe Converters do
  specify "hex_to_binary converts to a binary string" do
    expect(Converters.hex_to_binary("a0c2017")).to eq "1010000011000010000000010111"
  end
end

require "set"
class MemoryGrid
  include Converters

  EMPTY = "0"
  USED = "1"

  def initialize(input=nil, grid: [])
    if input
      @grid = (0..127).map do |i|
        hex_to_binary(KnotHash.hash("#{input}-#{i}"))
      end
    else
      @grid = grid
    end
  end

  def used
    @grid.join.gsub(EMPTY,"").length
  end

  def regions
    Graph.groups(graph).length
  end

  private

  def graph
    used = Set.new
    @grid.each_with_index do |row, row_index|
      row.chars.each_with_index do |cell, col_index|
        used << [row_index, col_index] if cell == USED
      end
    end

    used.each_with_object({}) do |cell, graph|
      graph[cell] = Set.new

      x, y = cell
      [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dx, dy|
        neighbor = [x + dx, y + dy]
        if used.include?(neighbor)
          graph[cell] << neighbor
        end
      end
    end
  end
end

describe MemoryGrid do
  describe "used" do
    specify "returns the number of used blocks" do
      grid = MemoryGrid.new("flqrgnkx")
      expect(grid.used).to eq 8108
    end
  end

  describe "regions" do
    let(:raw_grid) do
      [
        "11010100",
        "01010101",
        "00001010",
      ]
    end
    let(:grid) { MemoryGrid.new(grid: raw_grid) }

    specify "returns the number of regions" do
      expect(grid.regions).to eq 6
    end
  end
end

input = "stpzcrnm"
memory_grid = MemoryGrid.new(input)

# Part 1
puts memory_grid.used

# Part 2
puts memory_grid.regions
