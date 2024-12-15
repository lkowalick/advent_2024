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
  map_text, move_text = text.split("\n\n")
  pos = [nil, nil]
  map = map_text.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.map do |char, j|
      if char == ROB
        pos = [i, j]
        EMP
      else
        char
      end
    end
  end
  height = map.length
  width = map.first.length
  moves = move_text.each_char.filter do |char|
    MOVEMENT.include?(char)
  end
  { map: ,pos: , moves: , height:, width: }
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
        height: 8,
        width: 8,
      },
      parse_input(test_data_1),
    )
  end
end

