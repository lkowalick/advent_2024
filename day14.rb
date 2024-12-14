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

def parse_input2(text)
  text.split("\n\n").map do |chunk|
    a_dx, a_dy, b_dx, b_dy, x, y = chunk.scan(/\d+/).map(&:to_i)
    x += 10000000000000
    y += 10000000000000
    { a_dx:, a_dy:, b_dx:, b_dy:, x:, y: }
  end
end

# a_dx * A + b_dx * B = x
#
# A = ( x - b_dx * B ) / a_dx
#
# a_dy * (x - b_dx*B)/a_dx + b_dy*B = y
#
# a_dy * x / a_dx - a_dy*b_dx*B / a_dx + b_dy*B = y
#
# B * ( b_dy - (a_dy * b_dx)/a_dx) = y - a_dy * x / a_dx
#
# B = ( a_dx * y - a_dy*x) / (a_dx*b_dy - a_dy*b_dx)

def solve(system)
  system => { a_dx:, a_dy:, b_dx:, b_dy:, x:, y: }
  b = (a_dx*y - a_dy*x)/(a_dx*b_dy - a_dy*b_dx)
  a = (x - b_dx*b)/a_dx
  if a*a_dx + b*b_dx == x && a*a_dy + b*b_dy == y
    return { a:, b: }
  end
  {a: 0, b: 0}
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

  define_method :test_parse_input2 do
    assert_equal(
      [
        { a_dx: 94, b_dx: 22, a_dy: 34, b_dy: 67, x: 10000000008400, y: 10000000005400 },
        { a_dx: 26, b_dx: 67, a_dy: 66, b_dy: 21, x: 10000000012748, y: 10000000012176 },
        { a_dx: 17, b_dx: 84, a_dy: 86, b_dy: 37, x: 10000000007870, y: 10000000006450 },
        { a_dx: 69, b_dx: 27, a_dy: 23, b_dy: 71, x: 10000000018641, y: 10000000010279 },
      ],
      parse_input2(test_data),
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

  define_method :test_part1 do
    assert_equal(
      29187,
      compute_cost(parse_input(real_input))
    )
  end

  define_method :test_part2 do
    assert_equal(
      99968222587852,
      compute_cost(parse_input(real_input))
    )
  end
end

puts "part 2: #{compute_cost(parse_input2(real_input))}"

