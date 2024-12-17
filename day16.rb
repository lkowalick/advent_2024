#!/usr/bin/env ruby

require "minitest/autorun"
require 'algorithms'

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
  pos, finish = nil, nil
  maze = text.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.map do |char, j|
      case char
      when "S"
        pos = [i,j]
        "."
      when "E"
        finish = [i,j]
        char
      else
        char
      end
    end
  end
  facing = 0
  { maze:, pos:, facing:, finish: }
end

def solve(input)
  input => { maze:, pos: ,facing: }
  solve_helper(maze, [pos], facing)
end

def solve_with_limit(input, limit)
  input => { maze:, pos: ,facing: }
  solve_helper(maze, [pos], facing, limit)
end

#def get_seats(input)
#  limit = dijkstra(input)
#  solve_with_limit(input, limit).flatten.each_with_object(Set.new) do |pos, result|
#    result << pos
#  end.length
#end


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



def maze_to_string(input)
  input => { pos: , maze:, facing: }
  "position: #{pos.inspect} | facing: #{facing}\n" + maze.map { |row| row.join("") }.join("\n")
end

def solution_to_string(input)
  solution = solve(input)
  input => { pos: , maze:, facing: }
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

def get_reachable_vertices(input)
  input => { maze: , pos:, facing: }
  seen = Set.new()
  queue = [[pos, facing]]
  until queue.empty? do
    location, dir = queue.pop
    next if seen.include?([location,dir])
    seen << [location,dir]
    dij_neighbors(maze, location,dir).each do |neighbor|
      queue << neighbor
    end
  end
  seen
end

def dij_neighbors(maze, pos, dir)
  neighbors = [[pos,(dir+1)%4],[pos,(dir+3)%4]]
  x, y = pos
  dx, dy = DIR_OFFSETS.fetch(dir)
  adj_neighbors = [
    [[x+dx, y+dy], dir],
    [[x-dx, y-dy], dir],
  ].filter do |(x,y),_|
    maze[x][y] != "#"
  end
  neighbors + adj_neighbors
end

def dijkstra(input)
  input => { pos:, maze: , facing:, finish:}
  dist = {}
  queue = Containers::MinHeap.new
  seen = Set.new
  get_reachable_vertices(input).each do |vertex|
    dist[vertex] = Float::INFINITY
    queue.push(dist[vertex], vertex)
  end

  dist[[pos,facing]] = 0
  dist[[pos,(facing+1)%4]] = Float::INFINITY
  dist[[pos,(facing+2)%4]] = Float::INFINITY
  dist[[pos,(facing+3)%4]] = Float::INFINITY

  until queue.empty?
    u = queue.pop
    pos, dir = u
    next if seen.include?(u)
    seen << u

    dij_neighbors(maze, *u).each do |neighbor|
      neighbor_pos, neighbor_dir = neighbor
      next if seen.include?(neighbor)
      cost = if neighbor_dir == dir
               1
             else
               1000
             end
      new_dist = dist.fetch(u) + cost
       if new_dist < dist.fetch(neighbor)
         dist[neighbor] = new_dist
         queue.push(new_dist, neighbor)
       end
    end
  end


  [
    0.upto(3).map do |dir|
      dist[[finish, dir]]
    end.min,
    dist,
  ]
end

def get_seats(input)
  input => { maze:, facing: , pos:}
  min, dist = dijkstra(input)


  set = Set.new
  solve_helper_good(maze, Set.new,[pos,facing] , dist, min).each_slice(3) do |i,j,k|
    raise if i.nil? || j.nil? || k.nil?
    set << [i,j]
  end
  puts ""
  puts(maze.each_with_index.map do |row, i|
    row.each_with_index.map do |char, j|
      next("O") if set.include?([i,j])
      char
    end.join("")
  end.join("\n"))
  set.length
end


def solve_helper_good(maze, path, vertex, dist, min)
  pos, dir = vertex
  path << vertex
  result = dij_neighbors(maze,*vertex).map do |neighbor|
    next(nil) if path.include?(neighbor)
    neighbor_pos, neighbor_dir = neighbor
    cost = if neighbor_dir == dir
             1
           else
             1000
           end
    next(nil) unless dist[vertex] + cost == dist[neighbor] &&  dist[neighbor] <= min


    if maze.dig(*neighbor_pos) == "E"
      path.dup << neighbor
    else
      solve_helper_good(maze, path, neighbor, dist, min)
    end
  end.compact
  path.delete(vertex)
  if result.empty?
    nil
  else
    result.flatten
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


  define_method :test_dijkstra do
    assert_equal(7036, dijkstra(parse_input(test_data_1)).first)
    assert_equal(11048, dijkstra(parse_input(test_data_2)).first)
    #assert_equal(73404, dijkstra(parse_input(real_data)).first)
  end

  define_method :test_get_seats do
    #assert_equal(45, get_seats(parse_input(test_data_1)))
    assert_equal(64, get_seats(parse_input(test_data_2)))
  end
end

puts "part 2: #{get_seats(parse_input(real_data))}"

