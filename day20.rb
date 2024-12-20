#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day20_input.txt"

real_data = File.read(FILENAME)

test_data = <<~TEST.chomp
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
TEST

def parse_input(input)
  start, finish = nil, nil
  grid = input.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.map do |char, j|
      char.tap do |chr|
        start = [i,j] if chr == "S"
        finish = [i,j] if chr == "E"
      end
    end
  end

  { grid:, start:, finish: }
end

def render(grid)
  grid.map { |row| row.join("") }.join("\n")
end

def dijkstra(input)
  0
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(test_data, render(parse_input(test_data)[:grid]))
    assert_equal([3,1], parse_input(test_data)[:start])
    assert_equal([7,5], parse_input(test_data)[:finish])
  end

  define_method :test_dijkstra do
    assert_equal(84, dijkstra(parse_input(test_data)))
  end
end

