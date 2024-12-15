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
    moves.each do |move|
      self.pos = perform(move, pos) if can_perform?(move, pos)
    end
  end

  def can_perform?(move, pos)
    new_pos = neighbor(move, pos)
    new_square = map.dig(*new_pos)
    case new_square
    when EMP
      true
    when WAL
      false
    when BOX
      can_perform?(move, new_pos)
    end
  end

  def perform(move, pos)
    current_square = map.dig(*pos)
    new_pos = neighbor(move, pos)
    new_square = map.dig(*new_pos)
    case new_square
    when EMP
      self.map[pos[0]][pos[1]] = new_square
      self.map[new_pos[0]][new_pos[1]] = current_square
    when BOX
      perform(move, new_pos)
    else
      raise "unexpected wall at #{new_pos.inspect}"
    end
    new_pos
  end

  def neighbor(move, pos)
    case move
    when UP
      [pos[0]-1,pos[1]]
    when DN
      [pos[0]+1,pos[1]]
    when LT
      [pos[0],pos[1]-1]
    when RT
      [pos[0],pos[1]+1]
    end
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

