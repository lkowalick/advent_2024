#!/usr/bin/env ruby

require "minitest/autorun"

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
  blocks[0,12].each_with_object(Array.new(dimension) { Array.new(dimension) { "." } }) do |(i,j), grid|
    grid[i][j] = "#"
  end
end

def grid_to_s(grid)
  grid.map { |row| row.join("") }.join("\n")
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
end
