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

ParsedInput = Struct.new(:disk, :free_space, :ids)
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

  ParsedInput.new(disk, free_space, ids)
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
end
