#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day8_input.txt"

real_input = File.read(FILENAME)

test_data = <<-TEST
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
TEST

Result = Struct.new(:height, :width, :stations)
def parse_input(text)
  height = text.each_line.count
  width = 0
  text.each_line do |line|
    width = line.chomp.length
    break
  end


  Result.new(height, width, [])
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
  end
end
