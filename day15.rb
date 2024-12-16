#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day15_input.txt"

real_input = File.read(FILENAME)


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

test_data_3 = <<-TEST
#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^
TEST


class Rob
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

  def render
    self.map.map { |l| l.join("") }.join("\n")
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    instance = Rob.new(test_data_1)
    assert_equal(
      <<~TEST.chomp,
      ########
      #..O.O.#
      ##..O..#
      #...O..#
      #.#.O..#
      #...O..#
      #......#
      ########
      TEST
      instance.render
    )
    assert_equal([2,2], instance.pos)
    assert_equal(8, instance.height)
    assert_equal(8, instance.width)
  end

  define_method :test_can_perform do
    instance = Rob.new(test_data_1)
    refute(instance.can_perform?("<", instance.pos))
    assert(instance.can_perform?(">", instance.pos))
    assert(instance.can_perform?("^", instance.pos))
    assert(instance.can_perform?("v", instance.pos))
  end

  define_method :test_perform_moves_test_data_1 do
    instance = Rob.new(test_data_1)
    instance.perform_moves
    expected = <<~TEST.chomp
      ########
      #....OO#
      ##.....#
      #.....O#
      #.#O...#
      #...O..#
      #...O..#
      ########
      TEST

    assert_equal(expected, instance.render)
  end
  define_method :test_perform_moves_test_data_1 do
    instance = Rob.new(test_data_2)
    instance.perform_moves
    expected = <<~TEST.chomp
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
    assert_equal(expected, instance.render)
  end

  define_method :test_compute_gps_sum_1 do
    instance = Rob.new(test_data_1)
    instance.perform_moves
    assert_equal(2028, instance.compute_gps_sum)
  end

  define_method :test_compute_gps_sum_2 do
    instance = Rob.new(test_data_2)
    instance.perform_moves
    assert_equal(10_092, instance.compute_gps_sum)
  end

  define_method :test_compute_gps_sum_real do
    instance = Rob.new(real_input)
    instance.perform_moves
    assert_equal(1563092, instance.compute_gps_sum)
  end
end

class Robot2
  MAP_CHARS = [
    ROB = "@",
    BOX = "O",
    BOX_L = "[",
    BOX_R = "]",
    WAL = "#",
    EMP = ".",
  ]

  MOVEMENT = [
    UP = "^",
    DN = "v",
    LT = "<",
    RT = ">",
  ]
  attr_accessor :map, :pos, :moves, :height, :width
  def initialize(text_input)
    map_text, move_text = text_input.split("\n\n")
    self.pos = [nil, nil]
    self.map = map_text.each_line.with_index.map do |line, i|
      line.chomp.each_char.with_index.flat_map do |char, j|
        if char == ROB
          self.pos = [i, 2*j]
          [EMP, EMP]
        elsif char == BOX
          ["[","]"]
        else
          [char,char]
        end
      end
    end
    self.height = map.length
    self.width = map.first.length
    self.moves = move_text.each_char.filter do |char|
      MOVEMENT.include?(char)
    end
  end

  def render
    self.map.map { |l| l.join("") }.join("\n")
  end

  def perform_moves
    moves.each do |move|
      if robot_can_perform?(move, pos)
        self.pos = perform(move, pos)
      end
    end
  end

  def robot_can_perform?(move, pos)
    new_pos = neighbor(move, pos)
    new_square = map.dig(*new_pos)
    case new_square
    when EMP
      true
    when WAL
      false
    else
    end


  end

  def can_perform_box?(move, pos)

  end

  def can_perform_helper(move, pos)
    new_pos = neighbor(move, pos)
    new_square = map.dig(*new_pos)
    case new_square
    when BOX_L
      can_perform?(move, new_pos)
    when BOX_R
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


class WarehouseObject
  attr_accessor :i, :j

  def initialize(coord)
    @i, @j = coord
  end

  def occupied_spots
    [[i,j]]
  end

  def movable?
    true
  end

  def newly_occupied_spots(direction)
    move_coords(direction) - occupied_spots
  end

  def move_coords(direction)
    case direction
    when "^"
      occupied_spots.map { |i,j| [i-1,j] }
    when "v"
      occupied_spots.map { |i,j| [i+1,j] }
    when "<"
      occupied_spots.map { |i,j| [i,j-1] }
    when ">"
      occupied_spots.map { |i,j| [i,j+1] }
    end
  end
end

class Box < WarehouseObject
  def occupied_spots
    [
      [i, j],
      [i, j+1],
    ]
  end

  def to_s
    "[]"
  end
end

class Wall < WarehouseObject
  def movable?
    false
  end

  def to_s
    "#"
  end
end

class Empty < WarehouseObject
  def to_s
    "."
  end

  def move_coords(direction)
    [[i,j]]
  end
end

class Robot < WarehouseObject
  def to_s
    "@"
  end
end

class Warehouse
  attr_accessor :objects, :robot

  def initialize(grid)
    self.objects = Array.new(grid.length) { Array.new(grid.first.length) }
    grid.each_with_index do |row, i|
      row.each_with_index do |entry, j|
        new_object = case entry
                     when "@"
                       self.robot = Robot.new([i,j])
                     when "."
                       Empty.new([i,j])
                     when "#"
                       Wall.new([i,j])
                     when "["
                       Box.new([i,j])
                     when "]"
                       nil
                     end
        next unless new_object
        new_object.occupied_spots.each do |i,j|
          self.objects[i][j] = new_object
        end
      end
    end
  end

  def render
    self.objects.each_with_index.map do |row, i|
      row.each_with_index.map do |o, j|
        next("") unless [o.i,o.j] == [i,j]
        o.to_s
      end.join("")
    end.join("\n")
  end

  def can_move?(direction, pos)
    object = objects.dig(*pos)
    return false unless object.movable?
    object.newly_occupied_spots(direction).all? do |coord|
      can_move?(direction, coord)
    end
  end

  def move_object(direction, object)
    new_coords = object.newly_occupied_spots(direction)
    move_at_coordinates(direction, new_coords)
    object.occupied_spots.each do |coord|
      i, j = coord
      self.objects[i][j] = Empty.new([i,j])
    end
    object.i, object.j = object.move_coords(direction).first
    object.occupied_spots.each do |i,j|
      self.objects[i][j] = object
    end
  end

  def move_at_coordinates(direction, coords)
    objects_to_move = []
    coords.each do |coord|
      objects_to_move <<  objects.dig(*coord) unless objects_to_move.include?(objects.dig(*coord))
    end
    objects_to_move.each do |object|
      move_object(direction, object)
    end
  end

  def perform_move(direction)
    coord = [robot.i, robot.j]
    if can_move?(direction, coord)
      move_at_coordinates(direction, [coord])
    end
  end

  def compute_gps_sum
    objects.each_with_index.sum do |row, i|
      row.each_with_index.sum do |obj, j|
        next(0) unless obj.class == Box && obj.i == i && obj.j == j
        100*i + j
      end
    end
  end
end

def parse_input(text_input)
  map_text, move_text = text_input.split("\n\n")
  map = map_text.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.flat_map do |char, j|
      if char == "@"
        ["@", "."]
      elsif char == "O"
        ["[","]"]
      else
        [char,char]
      end
    end
  end
  moves = move_text.each_char.filter do |char|
    %w(^ v < >).include?(char)
  end
  { map:, moves: }
end

def compute_gps_sum_part2(text_input)
  parsed_input = parse_input(text_input)
  warehouse = Warehouse.new(parsed_input[:map])
  parsed_input[:moves].each do |move|
    warehouse.perform_move(move)
  end
  warehouse.compute_gps_sum
end

Class.new(Minitest::Test) do
  parsed_input = parse_input(test_data_3)
  define_method :test_parse_input do
    expected = <<~TEST.chomp
        ##############
        ##......##..##
        ##..........##
        ##....[][]@.##
        ##....[]....##
        ##..........##
        ##############
        TEST
    assert_equal(expected, Warehouse.new(parsed_input[:map]).render)
  end

  define_method :test_moving do
    warehouse = Warehouse.new(parsed_input[:map])

    warehouse.perform_move(parsed_input[:moves][0])
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##......##..##
        ##..........##
        ##...[][]@..##
        ##....[]....##
        ##..........##
        ##############
        TEST

    warehouse.perform_move(parsed_input[:moves][1])
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##......##..##
        ##..........##
        ##...[][]...##
        ##....[].@..##
        ##..........##
        ##############
        TEST

    warehouse.perform_move(parsed_input[:moves][2])
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##......##..##
        ##..........##
        ##...[][]...##
        ##....[]....##
        ##.......@..##
        ##############
        TEST

    warehouse.perform_move(parsed_input[:moves][3])
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##......##..##
        ##..........##
        ##...[][]...##
        ##....[]....##
        ##......@...##
        ##############
        TEST

    warehouse.perform_move(parsed_input[:moves][4])
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##......##..##
        ##..........##
        ##...[][]...##
        ##....[]....##
        ##.....@....##
        ##############
        TEST

    warehouse.perform_move(parsed_input[:moves][5])
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##......##..##
        ##...[][]...##
        ##....[]....##
        ##.....@....##
        ##..........##
        ##############
        TEST

  end

  define_method :test_perform_moves do
    warehouse = Warehouse.new(parsed_input[:map])
    parsed_input[:moves].each do |move|
      warehouse.perform_move(move)
    end
    assert_equal(<<~TEST.chomp, warehouse.render)
        ##############
        ##...[].##..##
        ##...@.[]...##
        ##....[]....##
        ##..........##
        ##..........##
        ##############
        TEST
  end

  define_method :test_perform_moves2 do
    parsed_input2 = parse_input(test_data_2)
    warehouse = Warehouse.new(parsed_input2[:map])
    parsed_input2[:moves].each do |move|
      warehouse.perform_move(move)
    end
    assert_equal(<<~TEST.chomp, warehouse.render)
      ####################
      ##[].......[].[][]##
      ##[]...........[].##
      ##[]........[][][]##
      ##[]......[]....[]##
      ##..##......[]....##
      ##..[]............##
      ##..@......[].[][]##
      ##......[][]..[]..##
      ####################
    TEST
  end

  define_method :test_compute_gps_sum_part2 do
    assert_equal(9021, compute_gps_sum_part2(test_data_2))
  end
end
