#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day14_input.txt"

real_input = File.read(FILENAME)

REAL_HEIGHT, REAL_WIDTH = 103, 101
TEST_HEIGHT, TEST_WIDTH = 7, 11

TEST_Q1_X, TEST_Q2_X = (0..4), (6..10)
TEST_Q1_Y, TEST_Q2_Y = (0..2), (4..6)

REAL_Q1_X, REAL_Q2_X = (0..50), (52..102)
REAL_Q1_Y, REAL_Q2_Y = (0..49), (51..100)

TEST_QUAD_1 = [TEST_Q1_X, TEST_Q1_Y]
TEST_QUAD_2 = [TEST_Q2_X, TEST_Q1_Y]
TEST_QUAD_3 = [TEST_Q2_X, TEST_Q2_Y]
TEST_QUAD_4 = [TEST_Q1_X, TEST_Q2_Y]

REAL_QUAD_1 = [REAL_Q1_X, REAL_Q1_Y]
REAL_QUAD_2 = [REAL_Q2_X, REAL_Q1_Y]
REAL_QUAD_3 = [REAL_Q2_X, REAL_Q2_Y]
REAL_QUAD_4 = [REAL_Q1_X, REAL_Q2_Y]

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

def compute_final_position(robot, height, width)
  robot => { x:, y:, dx:, dy: }
  [(x + 100*dx) % width, (y + 100*dy) % height]
end

def compute_quadrant(pos, test = true)
  if test
    compute_quadrant_test(pos)
  else
    compute_quadrant_real(pos)
  end
end

def compute_quadrant_test(pos)
  x, y = pos
  return nil if x == 5 || y == 3
  if TEST_Q1_X.include?(x)
    if TEST_Q1_Y.include?(y)
      1
    else
      4
    end
  else
    if TEST_Q1_Y.include?(y)
      2
    else
      3
    end
  end
end

def compute_quadrant_real(pos)
  x, y = pos
  return nil if x == 51 || y == 50
  if REAL_Q1_X.include?(x)
    if REAL_Q1_Y.include?(y)
      1
    else
      4
    end
  else
    if REAL_Q1_Y.include?(y)
      2
    else
      3
    end
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

  define_method :test_compute_quadrant do
    assert_equal(1, compute_quadrant_test([0,0]))
    assert_equal(1, compute_quadrant_test([0,0]))
    assert_equal(2, compute_quadrant_test([8,0]))
    assert_equal(3, compute_quadrant_test([8,5]))
    assert_equal(4, compute_quadrant_test([0,5]))
    assert_nil(compute_quadrant_test([5,0]))
    assert_nil(compute_quadrant_test([0,3]))

    assert_equal(1, compute_quadrant_real([0,0]))
    assert_equal(1, compute_quadrant_real([0,0]))
    assert_equal(2, compute_quadrant_real([70,0]))
    assert_equal(3, compute_quadrant_real([70,70]))
    assert_equal(4, compute_quadrant_real([0,70]))
    assert_nil(compute_quadrant_real([51,0]))
    assert_nil(compute_quadrant_real([0,50]))
  end
end

