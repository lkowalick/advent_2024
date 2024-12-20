#!/usr/bin/env ruby

require "minitest/autorun"
require "algorithms"

FILENAME = "./day20_input.txt"

real_data = File.read(FILENAME)

test_data = <<~TEST.chomp
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
TEST

def parse_input(input)
  start, finish = nil, nil
  grid = input.each_line.with_index.map do |line, i|
    line.chomp.each_char.with_index.map do |char, j|
      char.tap do |chr|
        start = [i,j] if chr == "S"
        finish = [i,j] if chr == "E"
      end
    end
  end

  { grid:, start:, finish: }
end

def render(grid)
  grid.map { |row| row.join("") }.join("\n")
end

def get_reachable_vertices(input)
  input => { grid:, start: }
  vertices = Set.new
  stack = [start]
  until stack.empty?
    coord = stack.pop
    next if vertices.include?(coord)
    vertices << coord
    stack.push(*neighbors(grid, *coord))
  end
  vertices
end

def neighbors(grid, i, j)
  [
    [i-1,j],
    [i+1,j],
    [i,j-1],
    [i,j+1],
  ].filter do |i,j|
    0 <= i && i < grid.length && 0 <= j && j < grid.first.length && grid[i][j] != "#"
  end
end

def neighbors_n(grid, i, j, n)
  2.upto(n).flat_map do |distance|
    0.upto(distance).flat_map do |i_offset|
      j_offset = distance - i_offset
      [
        [i+i_offset,j+j_offset],
        [i+i_offset,j-j_offset],
        [i-i_offset,j+j_offset],
        [i-i_offset,j-j_offset],
      ]
    end
  end.filter do |i,j|
    0 <= i && i < grid.length && 0 <= j && j < grid.first.length && grid[i][j] != "#"
  end
end

def dijkstra(input)
  input => { grid:, start:, finish: }
  dist = {}
  queue = Containers::MinHeap.new
  visited = Set.new
  get_reachable_vertices(input).each do |vertex|
    dist[vertex] = Float::INFINITY
    dist[vertex] = 0 if vertex == start
    queue.push(dist.fetch(vertex), vertex)
  end

  until queue.empty?
    coord = queue.pop
    next if visited.include?(coord)
    visited << coord
    neighbors(grid, *coord).each do |neighbor|
      new_dist = dist.fetch(coord) + 1
      if new_dist < dist.fetch(neighbor)
        dist[neighbor] = new_dist
        queue.push(dist.fetch(neighbor), neighbor)
      end
    end
  end

  return [dist.fetch(finish), dist]
end

def backwards_dijkstra(input)
  input[:start], input[:finish] = input[:finish], input[:start]
  dijkstra(input).tap do
    input[:finish], input[:start] = input[:start], input[:finish]
  end
end

def get_unique_cheats(input, shortcut_length, threshold)
  shorter = Set.new
  shortest, dist_start = dijkstra(input)
  _, dist_finish = backwards_dijkstra(input)
  input[:grid].each_with_index do |row, i|
    row.each_with_index do |elt, j|
      next if elt == "#"
      neighbors_n(input[:grid], i, j, shortcut_length).each do |neighbor|
        n_i, n_j = neighbor
        next unless dist_start.fetch([i,j]) < dist_start.fetch(neighbor)
        next unless dist_finish.fetch([i,j]) > dist_finish.fetch(neighbor)
        gap = shortest - (dist_start.fetch([i,j]) + dist_finish.fetch(neighbor))
        distance_between = (i - n_i).abs + (j - n_j).abs
        if gap > distance_between && dist_start.fetch([i,j]) + dist_finish.fetch(neighbor) + distance_between <= shortest - threshold
          shorter << [[i,j],neighbor].sort
        end
      end
    end
  end
  shorter.size
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(test_data, render(parse_input(test_data)[:grid]))
    assert_equal([3,1], parse_input(test_data)[:start])
    assert_equal([7,5], parse_input(test_data)[:finish])
  end

  define_method :test_dijkstra do
    assert_equal(84, dijkstra(parse_input(test_data)).first)
  end

  define_method :test_part_1 do
    assert_equal(1, get_unique_cheats(parse_input(test_data), 2, 64))
    assert_equal(1, get_unique_cheats(parse_input(test_data), 2, 41))
    assert_equal(2, get_unique_cheats(parse_input(test_data), 2, 40))
    assert_equal(3, get_unique_cheats(parse_input(test_data), 2, 38))
    assert_equal(4, get_unique_cheats(parse_input(test_data), 2, 36))
    assert_equal(5, get_unique_cheats(parse_input(test_data), 2,  20))
    assert_equal(1351, get_unique_cheats(parse_input(real_data), 2, 100).tap { |part_one| puts "\nPART ONE: #{part_one}" })
  end

  define_method :test_part_2 do
    assert_equal(3, get_unique_cheats(parse_input(test_data), 20, 76))
    assert_equal(3, get_unique_cheats(parse_input(test_data), 20, 75))
    assert_equal(7, get_unique_cheats(parse_input(test_data), 20, 74))
    assert_equal(7, get_unique_cheats(parse_input(test_data), 20, 73))
    assert_equal(29, get_unique_cheats(parse_input(test_data), 20, 72))
    assert_equal(29, get_unique_cheats(parse_input(test_data), 20, 71))
    assert_equal(41, get_unique_cheats(parse_input(test_data), 20, 70))
    assert_equal(966130, get_unique_cheats(parse_input(real_data), 20, 100).tap { |part_two| puts "\nPART TWO: #{part_two}" })
  end
end

