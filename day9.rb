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
  free_space = 0
  ids = {}
  text.chomp.each_char.each_slice(2).with_index do |slice, id|
    ids[id] = [disk.length]
    block_size = slice[0].to_i
    block_size.times { disk << id }
    ids[id] << disk.length
    next unless slice[1]
    free_size = slice[1].to_i
    free_size.times { disk << -1 }
    free_space += free_size
  end

  Struct.new(:disk, :free_space, :ids).new(disk, free_space, ids)
end

def compactify_and_compute_checksum(parsed_input)
  disk, free_space = parsed_input.disk, parsed_input.free_space
  disk = compactify_disk(disk, free_space)
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
  #puts "            #{disk.each_index.map {|i| "%#{disk[i].to_s.length+1}d" % i }.join(",")}"
  #puts "COMACTIFYING #{disk.inspect}"
  while free_space > 0 && left < right
    raise("right not right: #{right}: #{disk[right]}") if disk[right] == -1
    if disk[left] == -1
  #    puts "swapping disk[#{left}] == #{disk[left]} with disk[#{right}] == #{disk[right]} with freespace #{free_space}"
      disk[left], disk[right] = disk[right], disk[left]
      free_space -= 1
      begin
        right -= 1
      end while disk[right] == -1
    end
    left += 1
  end
  disk
end


Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      [0,1,2],
      parse_input(test_data_1).ids.keys
    )
    assert_equal(
      6,
      parse_input(test_data_1).free_space,
    )
    assert_equal(
      [0,1,2,3,4,5,6,7,8,9],
      parse_input(test_data_2).ids.keys
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
end

