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

def parse_input(text)
  pos, finish = nil, nil
  maze = text.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.map do |char, j|
      case char
      when "S"
        pos = [i,j]
        "."
      when "E"
        finish = [i,j]
        "."
      else
        char
      end
    end
  end
  facing = :e
  visited = Set.new([pos])
  { maze:, pos:, finish:, facing:, visited: }
end

def solve(maze)

end

def to_string(maze)
  maze => { pos: , maze:, finish:, facing: }
  "position: #{pos.inspect} | finish: #{finish.inspect} | facing: #{facing}\n" + maze.map { |row| row.join("") }.join("\n")
end

def neighbors(maze)
  maze => { pos: [i,j], maze:, visited: }
  [
    [i+1,j],[i-1,j],[i,j+1],[i,j-1],
  ].filter do |x,y|
    0 <= x && x < maze.length && 0 <= y && y < maze.first.length && maze[x][y] != "#" && !visited.include?([x,y])
  end
end


Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(<<~EXPECTED.chomp , to_string(parse_input(test_data_1)))
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

    assert_equal(<<~EXPECTED.chomp , to_string(parse_input(test_data_2)))
      position: [15, 1] | finish: [1, 15] | facing: e
      #################
      #...#...#...#...#
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
      #.#.............#
      #################
      EXPECTED
  end
end

