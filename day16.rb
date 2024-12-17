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
  pos = nil
  maze = text.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.map do |char, j|
      case char
      when "S"
        pos = [i,j]
        "."
      else
        char
      end
    end
  end
  facing = :e
  { maze:, pos:, facing: }
end

def solve(maze)
  maze => { maze:, pos: }
  solve_helper(maze, [pos])
end

def solve_helper(maze, path)
  neighbors(maze,path).each do |i,j|
    local_path = path.dup
    local_path << [i,j]
    return local_path if maze[i][j] == "E"
    recursive_sol = solve_helper(maze, local_path)
    return recursive_sol if recursive_sol
  end
  nil
end

def to_string(maze)
  maze => { pos: , maze:, facing: }
  "position: #{pos.inspect} | facing: #{facing}\n" + maze.map { |row| row.join("") }.join("\n")
end

def neighbors(maze, path)
  i,j = path[-1]
  [
    [i+1,j],[i-1,j],[i,j+1],[i,j-1],
  ].filter do |x,y|
    0 <= x && x < maze.length && 0 <= y && y < maze.first.length && maze[x][y] != "#" && !path.include?([x,y])
  end
end


Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(<<~EXPECTED.chomp , to_string(parse_input(test_data_1)))
      position: [13, 1] | facing: e
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
      #...#.....#...#
      ###############
      EXPECTED

    assert_equal(<<~EXPECTED.chomp , to_string(parse_input(test_data_2)))
      position: [15, 1] | facing: e
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
      #.#.............#
      #################
      EXPECTED
  end
end

puts "solution to test_data_1: #{solve((parse_input(test_data_2)))}"
