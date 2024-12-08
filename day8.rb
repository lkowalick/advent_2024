#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day7_input.txt"

real_input = File.read(FILENAME)

test_data = <<-TEST
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
TEST

def parse_to_result_and_operands(text)
  text.each_line.map do |line|
    ary = line.scan(/\d+/).map(&:to_i)
    [ary.first, ary[1..]]
  end
end

def is_possible_p1(result, operands)
  if operands.length == 1
    return result == operands.first
  end
  first, second = operands[0], operands[1]
  is_possible_p1(result, [first + second] + operands[2..]) ||
    is_possible_p1(result, [first * second] + operands[2..])
end

def is_possible_p2(result, operands)
  if operands.length == 1
    return result == operands.first
  end
  first, second = operands[0], operands[1]
  is_possible_p2(result, [first + second] + operands[2..]) ||
    is_possible_p2(result, [first * second] + operands[2..]) ||
    is_possible_p2(result, [(first.to_s + second.to_s).to_i] + operands[2..])
end

def compute_result_p1(results_and_operands)
  results_and_operands.map do |result, operands|
    next(result) if is_possible_p1(result, operands)
    0
  end.sum
end

def compute_result_p2(results_and_operands)
  results_and_operands.map do |result, operands|
    next(result) if is_possible_p2(result, operands)
    0
  end.sum
end

Class.new(Minitest::Test) do
  define_method :test_parse_to_result_and_operands do
    assert_equal(
      [
        [190, [10,19]],
        [3267, [81, 40, 27]],
        [83, [17, 5]],
        [156, [15, 6]],
        [7290, [6, 8, 6, 15]],
        [161011, [16, 10, 13]],
        [192, [17, 8, 14]],
        [21037, [9, 7, 18, 13]],
        [292, [11, 6, 16, 20]],
      ],
      parse_to_result_and_operands(test_data)
    )
  end

  define_method :test_compute_result_p1 do
    assert_equal(
      3749,
      compute_result_p1(parse_to_result_and_operands(test_data)),
    )

    assert_equal(
      6392012777720,
      compute_result_p1(parse_to_result_and_operands(real_input)),
    )
  end

  define_method :test_compute_result_p2 do
    assert_equal(
      11387,
      compute_result_p2(parse_to_result_and_operands(test_data)),
    )

    assert_equal(
      61561126043536,
      compute_result_p2(parse_to_result_and_operands(real_input)),
    )
  end
end
