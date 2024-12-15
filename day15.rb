#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day15_input.txt"

real_input = File.read(FILENAME)

MAP_CHARS = [
  ROB = "@",
  BOX = "O",
  WAL = "#",
  EMP = ".",
]

MOVEMENT = [
  UP = "^",
  DN = "v",
  LT = "<",
  RT = ">",
]

test_data_1 = <<-TEST
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
TEST

test_data_2 = <<-TEST
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
TEST

class Robot
  attr_accessor :map, :pos, :moves, :height, :width
  def initialize(text_input)
    map_text, move_text = text_input.split("\n\n")
    self.pos = [nil, nil]
    self.map = map_text.each_line.with_index.map do |line, i|
      line.chomp.each_char.with_index.map do |char, j|
        if char == ROB
          self.pos = [i, j]
          EMP
        else
          char
        end
      end
    end
    self.height = map.length
    self.width = map.first.length
    self.moves = move_text.each_char.filter do |char|
      MOVEMENT.include?(char)
    end
  end

  def perform_moves
    map
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    instance = Robot.new(test_data_1)
    assert_equal(
      [
        [WAL, WAL, WAL, WAL, WAL, WAL, WAL, WAL],
        [WAL, EMP, EMP, BOX, EMP, BOX, EMP, WAL],
        [WAL, WAL, EMP, EMP, BOX, EMP, EMP, WAL],
        [WAL, EMP, EMP, EMP, BOX, EMP, EMP, WAL],
        [WAL, EMP, WAL, EMP, BOX, EMP, EMP, WAL],
        [WAL, EMP, EMP, EMP, BOX, EMP, EMP, WAL],
        [WAL, EMP, EMP, EMP, EMP, EMP, EMP, WAL],
        [WAL, WAL, WAL, WAL, WAL, WAL, WAL, WAL],
      ],
      instance.map
    )
    assert_equal([2,2], instance.pos)
    assert_equal(8, instance.height)
    assert_equal(8, instance.width)
  end

  define_method :test_perform_moves do
    instance = Robot.new(test_data_1)
    instance.perform_moves
    assert_equal(
      [
        %w(# # # # # # # #),
        %w(# . . . . O O #),
        %w(# # . . . . . #),
        %w(# . . . . . O #),
        %w(# . # O . . . #),
        %w(# . . . O . . #),
        %w(# . . . O . . #),
        %w(# # # # # # # #),
      ],
      instance.map,
    )
  end
end

