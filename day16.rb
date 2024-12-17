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
  facing = 0
  { maze:, pos:, facing: }
end

def solve(maze)
  maze => { maze:, pos: ,facing: }
  solve_helper(maze, [pos], facing)
end


def get_cost(path)
  dir = 0
  path.each_cons(2).sum do |pos1, pos2|
    x1, y1 = pos1
    x2, y2 = pos2
    cost_of(pos1,pos2,dir).tap do
      dir = OFFSETS_TO_DIR.fetch([x2-x1,y2-y1])
    end
  end
end

DIR_OFFSETS = [[0,1], [1,0], [0,-1], [-1,0]]
OFFSETS_TO_DIR  = { [0,1] => 0, [1,0] => 1, [0,-1] => 2, [-1,0] => 3}
DIRECTIONS = %i(e s w n)

def cost_of(pos1, pos2, dir)
  return 1 if pos2 == travel(pos1, dir)
  return 1001 if pos2 == travel(pos1, (dir + 1) % 4)
  return 2001 if pos2 == travel(pos1, (dir + 2) % 4)
  return 1001 if pos2 == travel(pos1, (dir + 3) % 4)
  raise "INVALID MOVE #{pos1.inspect} to #{pos2.inspect}"
end


def travel(pos, dir)
  x,y = pos
  dx,dy = DIR_OFFSETS.fetch(dir)
  [x+dx, y+dy]
end

def solve_helper(maze, path, dir)
  neighbors(maze,path,dir).map do |i,j,dir|
    local_path = path.dup
    local_path << [i,j]
    return local_path if maze[i][j] == "E"
    recursive_sol = solve_helper(maze, local_path, dir)
    recursive_sol if recursive_sol
  end.compact.min_by { |path| get_cost(path) }
end

def maze_to_string(maze)
  maze => { pos: , maze:, facing: }
  "position: #{pos.inspect} | facing: #{facing}\n" + maze.map { |row| row.join("") }.join("\n")
end

def solution_to_string(maze)
  solution = solve(maze)
  maze => { pos: , maze:, facing: }
  maze.each_with_index.map do |row, i|
    row.each_with_index.map do |char, j|
      next("@") if solution.include?([i,j])
      char
    end.join("")
  end.join("\n")
end

def neighbors(maze, path, dir)
  i,j = path[-1]
  0.upto(3).map do |d_dir|
    current_dir =(dir + d_dir) % 4
    dx, dy = DIR_OFFSETS.fetch(current_dir)
    [i+dx, j+dy, current_dir]
  end.filter do |x,y,_|
    0 <= x && x < maze.length && 0 <= y && y < maze.first.length && maze[x][y] != "#" && !path.include?([x,y])
  end
end


Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(<<~EXPECTED.chomp , maze_to_string(parse_input(test_data_1)))
      position: [13, 1] | facing: 0
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

    assert_equal(<<~EXPECTED.chomp , maze_to_string(parse_input(test_data_2)))
      position: [15, 1] | facing: 0
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

  define_method :test_solution_cost do
    assert_equal(7036, get_cost(solve(parse_input(test_data_1))))
    assert_equal(11048, get_cost(solve(parse_input(test_data_2))))
  end
end

