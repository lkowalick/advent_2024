#!/usr/bin/env ruby

FILENAME = "./day4_input.txt"

real_input = File.read(FILENAME)

test = <<-TEST
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
TEST

def convert_to_grid(text)
  text.each_line.map do |line|
    line.chomp.each_char.to_a
  end
end

def xmas_or_samx?(arr)
  [%w(X M A S), %w(S A M X)].include?(arr)
end

def count_xmas(grid)
  horizontal = grid.sum do |line|
    line.each_cons(4).count(&method(:xmas_or_samx?))
  end

  vertical = grid.transpose.sum do |col|
    col.each_cons(4).count(&method(:xmas_or_samx?))
  end

  diag_dr_ul = grid.each_cons(4).sum do |row1,row2,row3,row4|
    grid.first.each_index.each_cons(4).count do |j1,j2,j3,j4|
      xmas_or_samx?([row1[j1],row2[j2],row3[j3],row4[j4]])
    end
  end

  diag_ur_dl = grid.each_cons(4).sum do |row1,row2,row3,row4|
    grid.first.each_index.each_cons(4).count do |j1,j2,j3,j4|
      xmas_or_samx?([row1[j4],row2[j3],row3[j2],row4[j1]])
    end
  end

  [
    horizontal,
    vertical,
    diag_dr_ul,
    diag_ur_dl,
  ].sum
end

#puts "TEST RESULT: #{count_xmas(convert_to_grid(test))}"
puts "RESULT part 1: #{count_xmas(convert_to_grid(real_input))}"


def extract_cross(grid, i_start, j_start)
  [
    grid[i_start][j_start],
    grid[i_start][j_start+2],
    grid[i_start+1][j_start+1],
    grid[i_start+2][j_start],
    grid[i_start+2][j_start+2],
  ]
end

def check_x_mas(grid, i_start, j_start)
  [
    %w(M M A S S),
    %w(S S A M M),
    %w(M S A M S),
    %w(S M A S M),
  ].include?(extract_cross(grid, i_start, j_start))
end

def count_x_mas(grid)
  grid.each_index.each_cons(3).sum do |i,_,_|
    grid.first.each_index.each_cons(3).count do |j,_,_|
      check_x_mas(grid, i, j)
    end
  end
end

#puts "TEST X-MAS: #{count_x_mas(convert_to_grid(test))}"
puts "RESULT part 2: #{count_x_mas(convert_to_grid(real_input))}"
