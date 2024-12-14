#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day14_input.txt"

real_input = File.read(FILENAME)

REAL_WIDTH, REAL_HEIGHT = 101, 103
TEST_WIDTH, TEST_HEIGHT = 11, 7

TEST_Q1_X, TEST_Q2_X = (0..4), (6..10)
TEST_Q1_Y, TEST_Q2_Y = (0..2), (4..6)

REAL_Q1_X, REAL_Q2_X = (0..49), (51..100)
REAL_Q1_Y, REAL_Q2_Y = (0..50), (52..102)

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

def compute_iteration_n(robot, n, height, width)
  robot => { x:, y:, dx:, dy: }
  [(x + n*dx) % width, (y + n*dy) % height]
end

def find_easter_egg_n(robots)
  1.upto(10_408).to_a.sort_by do |n|
    score(compute_quadrants_after_n(robots, n))
  end[-1..-1].each do |n|
    puts " FOR n #{n}"
    render(compute_quadrants_after_n(robots, n))
    puts ""
  end
end

def score(set_of_points)
  avg_x = (set_of_points.sum { |pt| pt.first }) / set_of_points.length

  set_of_points.count do |pt|
    set_of_points.include?(compute_mirror(pt, avg_x))
  end
end

def render(set_of_points)
  0.upto(REAL_HEIGHT - 1) do |y|
    0.upto(REAL_WIDTH - 1) do |x|
      if set_of_points.include?([x,y])
        print "X"
      else
        print "-"
      end
    end
    print ("\n")
  end
end


def compute_safety_factor_test(robots)
  robots.map do |robot|
    compute_quadrant_test(compute_final_position(robot, TEST_HEIGHT, TEST_WIDTH))
  end.compact.tally.values.reduce(:*)
end

def compute_mirror(pos, avg_x)
  x, y = pos
  [2*avg_x - x, y]
end

def compute_quadrants_after_n(robots, n)
  robots.each_with_object(Set.new) do |robot, result|
    result << compute_iteration_n(robot, n,REAL_HEIGHT, REAL_WIDTH)
  end
end

def compute_safety_factor_real(robots)
  robots.map do |robot|
    compute_quadrant_real(compute_final_position(robot, REAL_HEIGHT, REAL_WIDTH))
  end.compact.tally.values.reduce(:*)
end

def compute_quadrant_test(pos)
  x, y = pos
  return nil if x == 5 || y == 3
  [TEST_Q1_X.include?(x), TEST_Q1_Y.include?(y)]
end

def compute_quadrant_real(pos)
  x, y = pos
  return nil if x == 50 || y == 51
  [REAL_Q1_X.include?(x), REAL_Q1_Y.include?(y)]
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
    assert_equal([true,true], compute_quadrant_test([0,0]))
    assert_equal([true,true], compute_quadrant_test([0,0]))
    assert_equal([false,true], compute_quadrant_test([8,0]))
    assert_equal([false,false], compute_quadrant_test([8,5]))
    assert_equal([true,false], compute_quadrant_test([0,5]))
    assert_nil(compute_quadrant_test([5,0]))
    assert_nil(compute_quadrant_test([0,3]))

    assert_equal([true,true], compute_quadrant_real([0,0]))
    assert_equal([true,true], compute_quadrant_real([0,0]))
    assert_equal([false,true], compute_quadrant_real([70,0]))
    assert_equal([false,false], compute_quadrant_real([70,70]))
    assert_equal([true,false], compute_quadrant_real([0,70]))
    assert_nil(compute_quadrant_real([50,0]))
    assert_nil(compute_quadrant_real([0,51]))
  end

  define_method :test_compute_safety_factor_test do
    assert_equal(12, compute_safety_factor_test(parse_input(test_data)))
  end

  define_method :test_compute_safety_factor_real do
    assert_equal(226548000, compute_safety_factor_real(parse_input(real_input)))
  end
end

find_easter_egg_n(parse_input(real_input))

