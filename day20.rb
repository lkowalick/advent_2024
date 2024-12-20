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

  return dist.fetch(finish)
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(test_data, render(parse_input(test_data)[:grid]))
    assert_equal([3,1], parse_input(test_data)[:start])
    assert_equal([7,5], parse_input(test_data)[:finish])
  end

  define_method :test_dijkstra do
    assert_equal(84, dijkstra(parse_input(test_data)))
  end
end

