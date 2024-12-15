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

def parse_input(text)
  text.each_line.map do |line|
    x, y, dx, dy = line.scan(/-?\d+/).map(&:to_i)
    { x:, y:, dx:, dy: }
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      {
        map: [
          [WAL, WAL, WAL, WAL, WAL, WAL, WAL, WAL],
          [WAL, EMP, EMP, BOX, EMP, BOX, EMP, WAL],
          [WAL, WAL, EMP, EMP, BOX, EMP, EMP, WAL],
          [WAL, EMP, EMP, EMP, BOX, EMP, EMP, WAL],
          [WAL, EMP, WAL, EMP, BOX, EMP, EMP, WAL],
          [WAL, EMP, EMP, EMP, BOX, EMP, EMP, WAL],
          [WAL, EMP, EMP, EMP, EMP, EMP, EMP, WAL],
          [WAL, WAL, WAL, WAL, WAL, WAL, WAL, WAL],
        ],
        pos: [2,2],
        moves: [LT, UP, UP, RT, RT, RT, DN, DN, LT, DN, RT, RT, DN, LT, LT],
      },
      parse_input(test_data_1),
    )
  end
end

