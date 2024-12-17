#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day16_input.txt"

real_data = File.read(FILENAME)

test_data_1 = <<-TEST.chomp
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
TEST

test_data_2 = <<-TEST.chomp
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
TEST

DIRECTIONS = %i(e s w n)

class Maze
  attr_accessor :pos, :finish, :maze, :facing

  def initialize(text)
    self.maze = text.each_line.with_index.map do |line, i|
      line.chomp.each_char.with_index.map do |char, j|
        case char
        when "S"
          self.pos = [i,j]
          "."
        when "E"
          self.finish = [i,j]
          "."
        else
          char
        end
      end
    end
    self.facing = :e
  end

  def to_s
    "position: #{pos.inspect} | finish: #{finish.inspect} | facing: #{facing}\n" + maze.map { |row| row.join("") }.join("\n")
  end
end

def neighbors(grid, i, j)
  [
    [i+1,j],[i-1,j],[i,j+1],[i,j-1],
  ].filter do |x,y|
    0 <= x && x < grid.length && 0 <= y && y < grid.first.length
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(<<~EXPECTED.chomp , Maze.new(test_data_1).to_s)
      position: [13, 1] | finish: [1, 13] | facing: e
      ###############
      #.......#.....#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #...#.....#...#
      ###############
      EXPECTED

  end
end

