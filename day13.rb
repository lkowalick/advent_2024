#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day13_input.txt"

real_input = File.read(FILENAME)

test_data = <<-TEST
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
TEST


def parse_input(text)
  text.split("\n\n").map do |chunk|
    a_dx, a_dy, b_dx, b_dy, x, y = chunk.scan(/\d+/).map(&:to_i)
    { a_dx:, a_dy:, b_dx:, b_dy:, x:, y: }
  end
end

def solve(system)
  { a: 0, b: 0 }
end

def compute_cost(systems)
  systems.sum do |system|
    solution = solve(system)
    3 * solution[:a] + solution[:b]
  end
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(
      [
        { a_dx: 94, b_dx: 22, a_dy: 34, b_dy: 67, x: 8400, y: 5400 },
        { a_dx: 26, b_dx: 67, a_dy: 66, b_dy: 21, x: 12748, y: 12176 },
        { a_dx: 17, b_dx: 84, a_dy: 86, b_dy: 37, x: 7870, y: 6450 },
        { a_dx: 69, b_dx: 27, a_dy: 23, b_dy: 71, x: 18641, y: 10279 },
      ],
      parse_input(test_data),
    )
  end

  define_method :test_solve do
    assert_equal(
      { a: 80, b: 40 },
      solve({ a_dx: 94, b_dx: 22, a_dy: 34, b_dy: 67, x: 8400, y: 5400 }),
    )
    assert_equal(
      { a: 0, b: 0 },
      solve({ a_dx: 26, b_dx: 67, a_dy: 66, b_dy: 21, x: 12748, y: 12176 }),
    )
    assert_equal(
      { a: 38, b: 86 },
      solve({ a_dx: 17, b_dx: 84, a_dy: 86, b_dy: 37, x: 7870, y: 6450 }),
    )
    assert_equal(
      { a: 0, b: 0 },
      solve({ a_dx: 69, b_dx: 27, a_dy: 23, b_dy: 71, x: 18641, y: 10279 }),
    )
  end
end



