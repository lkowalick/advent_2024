#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day9_input.txt"

real_input = File.read(FILENAME)

test_data_1 = <<-TEST
12345
TEST

test_data_2= <<-TEST
2333133121414131402
TEST


def parse_input(text)
  disk = []
  free = []
  free_space = 0
  blocks = []
  text.chomp.each_char.each_slice(2).with_index do |slice, id|
    left = disk.length
    block_size = slice[0].to_i
    block_size.times { disk << id }
    right = disk.length - 1
    blocks[id] = [left, right]
    next unless slice[1]
    left = disk.length
    free_size = slice[1].to_i
    free_size.times { disk << -1 }
    right = disk.length - 1
    if right >= left
      free << [left, right]
    end
    free_space += free_size
  end

  Struct.new(:disk, :free_space, :free, :blocks).new(disk, free_space, free, blocks)
end

def parse_input2(text)
  disk = []


end

def compactify_and_compute_checksum(parsed_input)
  disk, free_space = parsed_input.disk, parsed_input.free_space
  disk = compactify_disk(disk, free_space)
  compute_checksum(disk)
end

def compactify2_and_compute_checksum(parsed_input)
  disk = compactify_disk2(parsed_input.disk, parsed_input.free, parsed_input.blocks)
  compute_checksum(disk)
end

def compute_checksum(disk)
  disk.each_with_index.map do |datum, i|
    if datum == -1
      0
    else
      datum * i
    end
  end.sum
end

def compactify_disk(disk, free_space)
  left, right = 0, disk.length - 1
  # invariants at start of loop
  # right always points to non-freespace disk[right] != -1
  while free_space > 0 && left < right
    raise("right not right: #{right}: #{disk[right]}") if disk[right] == -1
    if disk[left] == -1
      disk[left], disk[right] = disk[right], disk[left]
      free_space -= 1
      while disk[right] == -1
        right -= 1
      end
    end
    left += 1
  end
  disk
end

def compactify_disk2(disk, frees, blocks)
  (blocks.length - 1).downto(0).each do |i|
    block = blocks[i]
    length = block[1] - block[0] + 1
    0.upto(frees.length - 1).each do |j|
      free = frees[j]
      free_size = free[1] - free[0] + 1
      next unless free_size >= length && free[1] < block[0]
      disk[free[0],length] = [i] * length
      disk[block[0],length] = [-1] * length
      if free[1] - free[0] - length + 1 > 0
        frees[j] = [free[0]+length, free[1]]
      else
        frees.delete_at(j)
      end
      break
    end
  end
  disk
end


Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      6,
      parse_input(test_data_1).free_space,
    )
    assert_equal(
      [[1,2],[6,9]],
      parse_input(test_data_1).free,
    )
    assert_equal(
      [[0,0],[3,5],[10,14]],
      parse_input(test_data_1).blocks,
    )
    assert_equal(
      14,
      parse_input(test_data_2).free_space,
    )
  end

  define_method :test_compactify_disk do
    input = parse_input(test_data_1)
    assert_equal(
      [0,2,2,1,1,1,2,2,2,-1,-1,-1,-1,-1,-1],
      compactify_disk(input.disk, input.free_space),
    )
  end

  define_method :test_compactify_disk2 do
    input = parse_input(test_data_2)
    assert_equal(
      [0,0,9,9,2,1,1,1,7,7,7,-1,4,4,-1,3,3,3,-1,-1,-1,-1,5,5,5,5,-1,6,6,6,6,-1,-1,-1,-1,-1,8,8,8,8,-1,-1],
      compactify_disk2(input.disk, input.free, input.blocks),
    )
  end

  define_method :test_compute_checksum do
    assert_equal(
      1928,
      compactify_and_compute_checksum(parse_input(test_data_2)),
    )

    assert_equal(
      6349606724455,
      compactify_and_compute_checksum(parse_input(real_input)),
    )
  end

  define_method :test_compute_checksum2 do
    assert_equal(
      2858,
      compactify2_and_compute_checksum(parse_input(test_data_2)),
    )
  end
end

puts "part 2: #{compactify2_and_compute_checksum(parse_input(real_input))}"

