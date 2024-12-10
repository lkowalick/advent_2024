#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day10_input.txt"

real_input = File.read(FILENAME)

test_data = <<-TEST
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
TEST


def parse_input(text)
  text.each_line.map do |line|
    line.chomp.each_char.map(&:to_i).to_a
  end
end

def sum_trailhead_scores(grid)
  grid.each_index.flat_map do |i|
    grid[i].each_index.map do |j|
      next(0) unless grid[i][j] == 0
      count_summits(grid, i, j)
    end
  end.sum
end

def sum_trailhead_ratings(grid)
  grid.each_index.flat_map do |i|
    grid[i].each_index.map do |j|
      next(0) unless grid[i][j] == 0
      count_paths(grid, i, j)
    end
  end.sum
end

def path_helper(grid, paths, i, j, current_path)
  return unless grid[i][j] == current_path.length
  current_path << [i,j]
  if grid[i][j] == 9
    paths << current_path
  else
    neighbors(grid, i, j).each do |ni, nj|
      path_helper(grid, paths, ni, nj, current_path.dup)
    end
  end
end

def count_paths(grid, i, j)
  paths = Set.new

  path_helper(grid, paths, i ,j, [])
  paths.length
end


def count_summits(grid, i, j)
  summits = Set.new
  visited = Set.new
  stack = [[i,j]]
  while stack.length > 0
    ci,cj = stack.pop
    next if visited.include?([ci,cj])
    visited << [ci,cj]
    summits << [ci,cj] if grid[ci][cj] == 9
    neighbors(grid, ci, cj).each do |ni, nj|
      stack << [ni,nj] if grid[ni][nj] == grid[ci][cj] + 1
    end
  end
  summits.length
end

def neighbors(grid, i, j)
  [[i+1,j],[i-1,j],[i,j+1],[i,j-1]].filter do |i, j|
    0 <= i && i < grid.length && 0 <= j && j < grid.first.length
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      [
        [8, 9, 0, 1, 0, 1, 2, 3],
        [7, 8, 1, 2, 1, 8, 7, 4],
        [8, 7, 4, 3, 0, 9, 6, 5],
        [9, 6, 5, 4, 9, 8, 7, 4],
        [4, 5, 6, 7, 8, 9, 0, 3],
        [3, 2, 0, 1, 9, 0, 1, 2],
        [0, 1, 3, 2, 9, 8, 0, 1],
        [1, 0, 4, 5, 6, 7, 3, 2],
      ],
      parse_input(test_data),
    )
  end

  define_method :test_sum_trailhead_scores do
    assert_equal(
      36,
      sum_trailhead_scores(parse_input(test_data)),
    )

    assert_equal(
      674,
      sum_trailhead_scores(parse_input(real_input)),
    )
  end
  define_method :test_sum_trailhead_ratings do
    assert_equal(
      81,
      sum_trailhead_ratings(parse_input(test_data)),
    )
    assert_equal(
      1372,
      sum_trailhead_ratings(parse_input(real_input)),
    )
  end

end



