#!/usr/bin/env ruby

require "minitest/autorun"
FILENAME = "./day5_input.txt"

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
  starting_postion = nil
  grid = text.each_line.each_with_index.map do |line, i|
    line.chomp.each_char.each_with_index.map do |char, j|
      if char == "^"
        starting_postion = [i,j]
        char = "."
      end
      char
    end
  end
  [grid, starting_postion]
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

  def tick
    if in_bounds?(next_pos)
      if grid.dig(*next_pos) == "."
        visited << next_pos
        self.guard_pos = next_pos
      else
        self.guard_dir = (guard_dir + 1) % 4
        visited << next_pos
        self.guard_pos = next_pos
      end
    else
      self.guard_pos = next_pos
    end
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
