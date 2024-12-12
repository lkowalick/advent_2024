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
end


