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

def compute_antinodes1(pos1, pos2)
  x1, y1 = pos1
  x2, y2 = pos2
  dx = x2 - x1
  dy = y2 - y1
  [
    [pos1[0] - dx, pos1[1] - dy],
    [pos2[0] + dx, pos2[1] + dy],
  ]
end

def compute_antinodes2(pos1, pos2, height, width)
  x1, y1 = pos1
  x2, y2 = pos2
  dx = x2 - x1
  dy = y2 - y1
  result = [pos1, pos2]
  (1..).each do |i|
    new_x, new_y = pos2[0]+i*dx,pos2[1]+i*dy
    if 0 <= new_x && new_x < height && 0 <= new_y && new_y < width
      result << [new_x, new_y]
    else
      break
    end
  end
  (1..).each do |i|
    new_x, new_y = pos1[0]-i*dx,pos1[1]-i*dy
    if 0 <= new_x && new_x < height && 0 <= new_y && new_y < width
      result << [new_x, new_y]
    else
      break
    end
  end
  result
end

def count_inbounds_antinodes1(parsed_input)
  height, width = parsed_input.height, parsed_input.width
  antinodes = Set.new
  parsed_input.stations.each do |station, positions|
    positions.combination(2).each do |pos1, pos2|
      antinodes += compute_antinodes1(pos1, pos2)
    end
  end
  antinodes.count do |an|
    0 <= an[0] && an[0] < height && 0 <= an[1] && an[1] < width
  end
end

def count_inbounds_antinodes2(parsed_input)
  height, width = parsed_input.height, parsed_input.width
  antinodes = Set.new
  parsed_input.stations.each do |station, positions|
    positions.combination(2).each do |pos1, pos2|
      antinodes += compute_antinodes2(pos1, pos2, height, width)
    end
  end
  antinodes.count do |an|
    0 <= an[0] && an[0] < height && 0 <= an[1] && an[1] < width
  end
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
