#!/usr/bin/env ruby

require "minitest/autorun"
FILENAME = "./day6_input.txt"

REAL_INPUT = File.read(FILENAME)

TEST= <<-TEST
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
TEST

def input_to_grid_and_starting_position(text)
  starting_position = nil
  grid = text.each_line.each_with_index.map do |line, i|
    line.chomp.each_char.each_with_index.map do |char, j|
      if char == "^"
        starting_position = [i,j]
        char = "."
      end
      char
    end
  end
  [grid, starting_position]
end

class TestInputParse < Minitest::Test
  def test_input_grid
    assert_equal(
      [
        %w(. . . . # . . . . .),
        %w(. . . . . . . . . #),
        %w(. . . . . . . . . .),
        %w(. . # . . . . . . .),
        %w(. . . . . . . # . .),
        %w(. . . . . . . . . .),
        %w(. # . . . . . . . .),
        %w(. . . . . . . . # .),
        %w(# . . . . . . . . .),
        %w(. . . . . . # . . .),
      ],
      input_to_grid_and_starting_position(TEST)[0]
    )
  end

  def test_input_starting_position
    assert_equal(
      [6, 4],
      input_to_grid_and_starting_position(TEST)[1]
    )
  end
end

class Map
  DIRS = [
    UP = 0,
    RIGHT = 1,
    DOWN = 2,
    LEFT = 3,
  ]
  attr_accessor :grid, :visited, :guard_pos, :guard_dir, :height, :width
  def initialize(grid, starting_position)
    @grid = grid
    @height = grid.length
    @width = grid.first.length
    @visited = Set.new([starting_position])
    @guard_pos = starting_position
    @guard_dir = UP
  end

  def guard_in_bounds?
    in_bounds?(guard_pos)
  end

  def in_bounds?(pos)
    0 <= pos[0] && pos[0] < height && 0 <= pos[1] && pos[1] < width
  end

  def next_dir
    (guard_dir + 1) % 4
  end

  def tick
    if in_bounds?(next_pos)
      self.guard_dir = next_dir if grid.dig(*next_pos) == "#"
      self.visited << next_pos
    end
    self.guard_pos = next_pos
  end

  def distinct_positions
    while guard_in_bounds? do
      tick
    end
    visited.length
  end

  def next_pos
    case guard_dir
    when UP
      [guard_pos[0] - 1, guard_pos[1]]
    when DOWN
      [guard_pos[0] + 1, guard_pos[1]]
    when LEFT
      [guard_pos[0], guard_pos[1] - 1]
    when RIGHT
      [guard_pos[0], guard_pos[1] + 1]
    end
  end
end

def calculate_distinct_positions(text)
  grid, starting_position = input_to_grid_and_starting_position(text)
  Map.new(grid, starting_position).distinct_positions
end

class TestTestData < Minitest::Test
  def test_test_data
    assert_equal(
      41,
      calculate_distinct_positions(TEST),
    )
  end
end

class TestRealData < Minitest::Test
  def test_real_data
    assert_equal(
      5030,
      calculate_distinct_positions(REAL_INPUT),
    )
  end
end

puts "RESULT part 1: #{calculate_distinct_positions(REAL_INPUT)}"