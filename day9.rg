#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day9_input.txt"

real_input = File.read(FILENAME)

test_data = <<-TEST
2333133121414131402
TEST

ParsedInput = Struct.new(:height, :width, :stations)
def parse_input(text)
  disk = []
  free_space = 0
  text.chomp.each_char.each_slice.each_with_index do |slice, id|
    block_size = slice[0].to_i
    block_size.times { disk << id }
    next unless slice[1]
    free_size = slice[1].to_i
    free_size.times { disk << -1 }
    free_space += free_size
  end

  ParsedInput.new(disk, free_space)
end




Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      12,
      parse_input(test_data).height,
    )

    assert_equal(
      12,
      parse_input(test_data).width,
    )

    assert_equal(
      [[1,8],[2,5],[3,7],[4,4]],
      parse_input(test_data).stations["0"]
    )
    assert_equal(
      [[5,6],[8,8],[9,9]],
      parse_input(test_data).stations["A"]
    )
  end

  define_method :test_compute_antinodes do
    assert_equal(
      [[0,0],[9,12]],
      compute_antinodes1([3,4],[6,8])
    )
  end

  define_method :test_compute_inbounds_antinodes1 do
    assert_equal(
      14,
      count_inbounds_antinodes1(parse_input(test_data)),
    )

    assert_equal(
      392,
      count_inbounds_antinodes1(parse_input(real_input)),
    )
  end

  define_method :test_compute_inbounds_antinodes2 do
    assert_equal(
      34,
      count_inbounds_antinodes2(parse_input(test_data))
    )
    assert_equal(
      1235,
      count_inbounds_antinodes2(parse_input(real_input))
    )
  end
end
