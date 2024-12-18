#!/usr/bin/env ruby

require "minitest/autorun"
require "algorithms"

FILENAME = "./day18_input.txt"

real_data = { data: File.read(FILENAME), dimension: 71 }

test_data = { data: <<~TEST.chomp, dimension: 7 }
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
TEST

def create_grid(input, limit)
  input => { data:, dimension: }
  blocks = data.each_line.map { |l| l.chomp.scan(/\d+/).map(&:to_i).reverse }
  blocks[0,limit].each_with_object(Array.new(dimension) { Array.new(dimension) { "." } }) do |(i,j), grid|
    grid[i][j] = "#"
  end
end

def grid_to_s(grid)
  grid.map { |row| row.join("") }.join("\n")
end

def get_reachable_vertices(grid)
  stack = [[0,0]]
  visited = Set.new()
  until stack.empty?
    coord = stack.pop
    next if visited.include?(coord)
    visited << coord
    stack.concat(neighbors(grid, *coord))
  end
  visited
end

def neighbors(grid, i, j)
  [
    [i-1,j],[i+1,j],[i,j-1],[i,j+1]
  ].filter { |coord| coord.none?(&:negative?) && grid.dig(*coord) == "." }
end

def dijkstra(grid)
  queue = Containers::MinHeap.new
  visited = Set.new
  dist = {}
  get_reachable_vertices(grid).each do |vertex|
    dist[vertex] = Float::INFINITY
    dist[vertex] = 0 if vertex == [0,0]
    queue.push(dist[vertex], vertex)
  end

  until queue.empty?
    u = queue.pop
    next if visited.include?(u)
    visited << u

    neighbors(grid, *u).each do |neighbor|
      next if visited.include?(neighbor)
      new_dist = dist[u] + 1
      if new_dist < dist[neighbor]
        dist[neighbor] = new_dist
        queue.push(new_dist, neighbor)
      end
    end
  end
  dist[[grid.length - 1, grid.first.length - 1]]
end

def make(union_find, coord)
  return if union_find.key?(coord)
  union_find[coord] = { p: coord, size: 0 }
end

def find(union_find, coord)
  raise unless
end

def union(union_find, coord1, coord2)

end

# grid should be with maximal bytes, blocks is backwards)
def part_two(grid, blocks)
  union_find = {}
  grid.each_index do |i|
    grid.each_index do |j|
      make(union_find, [i,j])
      neighbors(grid, i, j).each do |neighbor|

      end



    end
  end

  # loop through the grid, MAKE-ing new union find trees
  # for each element that isn't a #, and UNIONng each
  # each element with its neighbors

  # assert that the start and end point are in separate trees

  # loop over blocks
  # For each block MAKE a new union find element
  # UNION block with each of its neighbors represented in the existing
  # union-find structure
  #
  # IF the start and end are in the same union-find tree, return the block reversed
end

Class.new(Minitest::Test) do
  define_method :test_create_grid do
    assert_equal(<<~EXPECTED.chomp, grid_to_s(create_grid(test_data, 12)))
                 ...#...
                 ..#..#.
                 ....#..
                 ...#..#
                 ..#..#.
                 .#..#..
                 #.#....
                 EXPECTED
  end

  define_method :test_dijkstra do
    assert_equal(22, dijkstra(create_grid(test_data, 12)))
  end
end

puts "PART 1: #{dijkstra(create_grid(real_data, 1024))}"
