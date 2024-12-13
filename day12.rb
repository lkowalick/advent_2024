#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day12_input.txt"
VISITED = "*"

real_data = File.read(FILENAME)
test_data_1 = <<-TEST
AAAA
BBCD
BBCC
EEEC
TEST
test_data_2 = <<-TEST
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
TEST

test_data_3 = <<-TEST
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
TEST

def parse_input(text)
  text.each_line.map { |l| l.chomp.each_char.to_a }
end

def count_regions(grid)
  grid.each_index.sum do |i|
    grid.first.each_index.sum do |j|
      next(0) if grid[i][j] == VISITED
      visit(grid, i ,j, grid[i][j], Set.new)
      1
    end
  end
end

def total_cost(grid)
  grid.each_index.sum do |i|
    grid.first.each_index.sum do |j|
      next(0) if grid[i][j] == VISITED
      region_members = Set.new
      visit(grid, i ,j, grid[i][j], region_members)
      tabulate_cost(region_members)
    end
  end
end

def total_cost_discounted(grid)
  grid.each_index.sum do |i|
    grid.first.each_index.sum do |j|
      next(0) if grid[i][j] == VISITED
      region_members = Set.new
      visit(grid, i ,j, grid[i][j], region_members)
      tabulate_cost_discounted(region_members)
    end
  end
end

def count_sides(region_members)
  visited = Set.new
  perimeter_edges = get_perimeter_edges(region_members)
  perimeter_edges.sum do |edge|
    next(0) if visited.member?(edge)
    visit_edge(edge, perimeter_edges, visited)
    1
  end
end

def visit_edge(edge, perimeter_edges, visited)
  return if visited.member?(edge)
  visited << edge
  edge_neighbors(edge).each do |neighbor_edge|
    next unless perimeter_edges.member?(neighbor_edge)
    visit_edge(neighbor_edge, perimeter_edges, visited)
  end
end

def edge_neighbors(edge)
  i_1,j_1 = edge.first
  i_2,j_2 = edge.last
  if horizontal?(edge)
    [
      [ # left neighbor
        [i_1,j_1-1],
        [i_2,j_2-1],
      ],
      [ # right neighbor
        [i_1,j_1+1],
        [i_2,j_2+1],
      ],
    ]
  else # edge is vertical
    [
      [ # top neighbor
        [i_1-1,j_1],
        [i_2-1,j_2],
      ],
      [ # bottom neighbor
        [i_1+1,j_1],
        [i_2+1,j_2],
      ],
    ]
  end
end

def horizontal?(edge)
  edge.first.last == edge.last.last
end

def tabulate_cost(region_members)
  get_perimeter_edges(region_members).length * region_members.length
end

def tabulate_cost_discounted(region_members)
  count_sides(region_members) * region_members.length
end

def get_perimeter_edges(region_members)
  perimeter_edges = Set.new
  region_members.each do |i,j|
    edges(i,j).each do |edge|
      if perimeter_edges.member?(edge.reverse)
        perimeter_edges.delete(edge.reverse)
      else
        perimeter_edges << edge
      end
    end
  end
  perimeter_edges
end

def visit(grid, i, j, initial_value, region_members)
  return unless grid[i][j] == initial_value
  grid[i][j] = VISITED
  region_members << [i,j]
  neighbors(grid, i ,j).each do |n_i, n_j|
    visit(grid, n_i, n_j, initial_value, region_members)
  end
end

# edges are oriented pairs of grid positions
# if they are sorted, the edge goes up or right
# if they are reverse sorted, the edge goes down or left
# NOTE: the edges of the grid are represented by
# out-of-bounds grid positions
def edges(i,j)
  [
    [[i-1,j],[i,j]],
    [[i,j-1],[i,j]],
    [[i+1,j],[i,j]],
    [[i,j+1],[i,j]],
  ]
end

def neighbors(grid, i, j)
  [
    [i+1,j],[i-1,j],[i,j+1],[i,j-1],
  ].filter do |x,y|
    0 <= x && x < grid.length && 0 <= y && y < grid.first.length
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      [
        %w(A A A A),
        %w(B B C D),
        %w(B B C C),
        %w(E E E C),
      ],
      parse_input(test_data_1),
    )

    assert_equal(
      [
        %w(O O O O O),
        %w(O X O X O),
        %w(O O O O O),
        %w(O X O X O),
        %w(O O O O O),
      ],
      parse_input(test_data_2),
    )

    assert_equal(
      [
        %w(R R R R I I C C F F),
        %w(R R R R I I C C C F),
        %w(V V R R R C C F F F),
        %w(V V R C C C J F F F),
        %w(V V V V C J J C F E),
        %w(V V I V C C J J E E),
        %w(V V I I I C J J E E),
        %w(M I I I I I J J E E),
        %w(M I I I S I J E E E),
        %w(M M M I S S J E E E),
      ],
      parse_input(test_data_3),
    )
  end

  define_method :test_count_regions do
    assert_equal(5,  count_regions(parse_input(test_data_1)))
    assert_equal(5,  count_regions(parse_input(test_data_2)))
    assert_equal(11, count_regions(parse_input(test_data_3)))
  end
  define_method :test_total_cost do
    assert_equal(140,       total_cost(parse_input(test_data_1)))
    assert_equal(772,       total_cost(parse_input(test_data_2)))
    assert_equal(1_930,     total_cost(parse_input(test_data_3)))
    assert_equal(1_449_902, total_cost(parse_input(real_data)))
  end

  define_method :test_count_sides do
    assert_equal(
      4,
      count_sides(Set[[0,0],[0,1],[0,2],[0,3]])
    )
    assert_equal(
      12,
      count_sides(Set[
        [0,0],[0,1],[0,2],[0,3],[0,4],
        [1,0],
        [2,0],[2,1],[2,2],[2,3],[2,4],
        [3,0],
        [4,0],[4,1],[4,2],[4,3],[4,4],
      ])
    )
  end

  define_method :test_total_cost_discounted do
    assert_equal(80,   total_cost_discounted(parse_input(test_data_1)))
    assert_equal(436,   total_cost_discounted(parse_input(test_data_2)))
    e_shaped = <<-INPUT
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
INPUT
    assert_equal(
      236,
      total_cost_discounted(parse_input(e_shaped)),
    )
    other_test_input_1 = <<-INPUT
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
INPUT
    assert_equal(
      368,
      total_cost_discounted(parse_input(other_test_input_1)),
    )
  end
end

puts "part2: #{total_cost_discounted(parse_input(real_data))}"
