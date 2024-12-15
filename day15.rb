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
      if can_perform?(move, pos)
        self.pos = perform(move, pos)
      end
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

  def perform(move, position)
    new_pos = neighbor(move, position)
    new_square = map.dig(*new_pos)
    perform(move, new_pos) if new_square == BOX
    self.map[position[0]][position[1]], self.map[new_pos[0]][new_pos[1]] = map.dig(*new_pos), map.dig(*position)
    new_pos
  end

  def neighbor(move, position)
    case move
    when UP
      [position[0]-1,position[1]]
    when DN
      [position[0]+1,position[1]]
    when LT
      [position[0],position[1]-1]
    when RT
      [position[0],position[1]+1]
    end
  end

  def compute_gps_sum
    map.each_with_index.sum do |row, i|
      row.each_with_index.sum do |chr, j|
        next(0) unless chr == BOX
        100*i + j
      end
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

  define_method :test_can_perform do
    instance = Robot.new(test_data_1)
    refute(instance.can_perform?(LT, instance.pos))
    assert(instance.can_perform?(RT, instance.pos))
    assert(instance.can_perform?(UP, instance.pos))
    assert(instance.can_perform?(DN, instance.pos))
  end

  define_method :test_perform_moves_test_data_1 do
    instance = Robot.new(test_data_1)
    instance.perform_moves
    expected= [ %w(# # # # # # # #),
                %w(# . . . . O O #),
                %w(# # . . . . . #),
                %w(# . . . . . O #),
                %w(# . # O . . . #),
                %w(# . . . O . . #),
                %w(# . . . O . . #),
                %w(# # # # # # # #),
    ]

    assert_equal(
      expected,
      instance.map,
      "EXPECTED:\n#{expected.map { |l| l.join("") }.join("\n")}\n
      GOT:\n#{instance.map.map { |l| l.join("") }.join("\n")}"
    )
  end
  define_method :test_perform_moves_test_data_1 do
    instance = Robot.new(test_data_2)
    instance.perform_moves
    expected = <<~TEST
      ##########
      #.O.O.OOO#
      #........#
      #OO......#
      #OO......#
      #O#.....O#
      #O.....OO#
      #O.....OO#
      #OO....OO#
      ##########
      TEST
    assert_equal(
      expected.chomp,
      instance.map.map { |l| l.join("") }.join("\n")
    )
  end

  define_method :test_compute_gps_sum_1 do
    instance = Robot.new(test_data_1)
    instance.perform_moves
    assert_equal(2028, instance.compute_gps_sum)
  end

  define_method :test_compute_gps_sum_2 do
    instance = Robot.new(test_data_2)
    instance.perform_moves
    assert_equal(10_092, instance.compute_gps_sum)
  end

  define_method :test_compute_gps_sum_real do
    instance = Robot.new(real_input)
    instance.perform_moves
    assert_equal(1563092, instance.compute_gps_sum)
  end
end
