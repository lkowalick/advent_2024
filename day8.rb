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

ParsedInput = Struct.new(:height, :width, :stations)
def parse_input(text)
  height = text.each_line.count
  width = 0
  stations = Hash.new { |h, k| h[k] = [] }
  text.each_line.each_with_index do |line, i|
    line.chomp!
    width = line.length
    line.each_char.each_with_index do |char, j|
      next if char == "."
      stations[char] << [i,j]
    end
  end


  ParsedInput.new(height, width, stations)
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
end
