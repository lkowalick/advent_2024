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


