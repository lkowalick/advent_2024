#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day9_input.txt"

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
    line.chomp.each_char.to_a
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      [
      %w(8 9 0 1 0 1 2 3),
      %w(7 8 1 2 1 8 7 4),
      %w(8 7 4 3 0 9 6 5),
      %w(9 6 5 4 9 8 7 4),
      %w(4 5 6 7 8 9 0 3),
      %w(3 2 0 1 9 0 1 2),
      %w(0 1 3 2 9 8 0 1),
      %w(1 0 4 5 6 7 3 2),
      ],
      parse_input(test_data),
    )
  end
end



