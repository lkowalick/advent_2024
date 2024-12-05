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

def count_xmas(grid)
  number_of_horz_forward = 0
  number_of_horz_backward = 0

  grid.each do |line|
    line_forward = 0
    line_backward = 0
    line.each_cons(4) do |cons|
      if cons == %w(X M A S)
        number_of_horz_forward += 1
        line_forward += 1
      elsif cons == %w(S A M X)
        number_of_horz_backward += 1
        line_backward += 1
      end
    end
  end

  number_of_vertical_forward = 0
  number_of_vertical_backward = 0

  grid_t = grid.transpose
  grid_t.each do |col|
    col.each_cons(4) do |cons|
      if cons == %w(X M A S)
        number_of_vertical_forward += 1
      elsif cons == %w(S A M X)
        number_of_vertical_backward += 1
      end
    end
  end

  number_of_diag_downright = 0
  number_of_diag_upleft = 0


  0.upto(grid.length - 4).each do |i|
    0.upto(grid[i].length - 4).each do |j|
      down_right = [grid[i][j],grid[i+1][j+1],grid[i+2][j+2],grid[i+3][j+3]]
      if down_right == %w(X M A S)
        number_of_diag_downright += 1
      elsif down_right == %w(S A M X)
        number_of_diag_upleft += 1
      end
    end
  end

  number_of_diag_upright = 0
  number_of_diag_downleft = 0
  0.upto(grid.length - 4).each do |i|
    3.upto(grid[i].length - 1).each do |j|
      downleft = [grid[i][j],grid[i+1][j-1],grid[i+2][j-2],grid[i+3][j-3]]
      if downleft == %w(X M A S)
        number_of_diag_downleft += 1
      elsif downleft == %w(S A M X)
        number_of_diag_upright += 1
      end
    end
  end

  [
    number_of_horz_forward,
    number_of_horz_backward,
    number_of_vertical_forward,
    number_of_vertical_backward,
    number_of_diag_downright,
    number_of_diag_upleft,
    number_of_diag_upright,
    number_of_diag_downleft,
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

def check_mmass(grid, i_start, j_start)
  %w(M M A S S) == extract_cross(grid, i_start, j_start)
end

def check_ssamm(grid, i_start, j_start)
  %w(S S A M M) == extract_cross(grid, i_start, j_start)
end

def check_msams(grid, i_start, j_start)
  %w(M S A M S) == extract_cross(grid, i_start, j_start)
end

def check_smasm(grid, i_start, j_start)
  %w(S M A S M) == extract_cross(grid, i_start, j_start)
end

def check_x_mas(*args)
  check_mmass(*args) || check_ssamm(*args) || check_msams(*args) || check_smasm(*args)
end

def count_x_mas(grid)
  count = 0
  0.upto(grid.length - 3).each do |i|
    0.upto(grid[i].length - 3).each do |j|
      if check_x_mas(grid, i, j)
        count += 1
      end
    end
  end
  count
end

puts "TEST X-MAS: #{count_x_mas(convert_to_grid(test))}"
puts "RESULT part 2: #{count_x_mas(convert_to_grid(real_input))}"