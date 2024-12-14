#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day14_input.txt"

real_input = File.read(FILENAME)

real_height, real_width = 103, 101
test_height, test_width = 7, 11

test_data = <<-TEST
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
TEST

def parse_input(text)
  text.each_line.map do |line|
    x, y, dx, dy = line.scan(/-?\d+/).map(&:to_i)
    { x:, y:, dx:, dy: }
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      [
        { x: 0,  y: 4, dx:  3, dy: -3 },
        { x: 6,  y: 3, dx: -1, dy: -3 },
        { x: 10, y: 3, dx: -1, dy:  2 },
        { x: 2,  y: 0, dx:  2, dy: -1 },
        { x: 0,  y: 0, dx:  1, dy:  3 },
        { x: 3,  y: 0, dx: -2, dy: -2 },
        { x: 7,  y: 6, dx: -1, dy: -3 },
        { x: 3,  y: 0, dx: -1, dy: -2 },
        { x: 9,  y: 3, dx:  2, dy:  3 },
        { x: 7,  y: 3, dx: -1, dy:  2 },
        { x: 2,  y: 4, dx:  2, dy: -3 },
        { x: 9,  y: 5, dx: -3, dy: -3 },
      ],
      parse_input(test_data),
    )
  end
end

