blocks = %w[0	5	10 0 11 14 13 4 11 8 8 7 1 4 12 11].map(&:to_i)
test_blocks = [0, 2, 7, 0]

def redistribute(blocks)
  blocks = blocks.dup
  max_index = 0
  blocks.each_with_index { |n, i| max_index = i if blocks[max_index] < n }
  block_count = blocks[max_index]
  blocks[max_index] = 0
  while block_count > 0
    max_index += 1
    block_count -= 1
    blocks[max_index % blocks.length] += 1
  end
  blocks
end

configs = [blocks]
until configs.include?(new_config = redistribute(configs.last))
  configs << new_config
end

puts configs.length - configs.index(new_config)

