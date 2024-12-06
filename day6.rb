#!/usr/bin/env ruby

require "minitest/autorun"
FILENAME = "./day5_input.txt"

REAL_INPUT = File.read(FILENAME)

TEST= <<-TEST
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
TEST

def input_to_deps_and_updates(text)
  deps_text, updates_text = text.split("\n\n")
  [
    deps_text.each_line.map { |l| l.scan(/\d+/) },
    updates_text.each_line.map { |l| l.scan(/\d+/) },
  ]
end

class TestInputParse < Minitest::Test
  def test_input_parse_deps
    assert_equal(
      [
        %w(47 53),
        %w(97 13),
        %w(97 61),
        %w(97 47),
        %w(75 29),
        %w(61 13),
        %w(75 53),
        %w(29 13),
        %w(97 29),
        %w(53 29),
        %w(61 53),
        %w(97 53),
        %w(61 29),
        %w(47 13),
        %w(75 47),
        %w(97 75),
        %w(47 61),
        %w(75 61),
        %w(47 29),
        %w(75 13),
        %w(53 13),
      ],
      input_to_deps_and_updates(TEST)[0]
    )
  end

  def test_input_parse_updates
    assert_equal(
      [
        %w(75 47 61 53 29),
        %w(97 61 53 29 13),
        %w(75 29 13),
        %w(75 97 47 61 53),
        %w(61 13 29),
        %w(97 13 75 29 47),
      ],
      input_to_deps_and_updates(TEST)[1]
    )
  end
end


class PageOrderValidator
  attr_reader :dep_graph
  def initialize(deps)
    create_graph(deps)
  end

  def valid?(updates)
    updates.combination(2).none? do |a, b|
      dep_graph[b].include?(a)
    end
  end

  def fix_update(update)
    raise "tryed to fix a valid update! #{update}" if valid?(update)
    in_degrees = generate_in_degrees(update)
    queue = update.filter { |key| in_degrees[key] == 0}
    result = []
    until queue.empty? do
      elt = queue.shift
      result << elt
      dep_graph[elt].filter { |e| update.include?(e) }.each do |dep|
        in_degrees[dep] -= 1
        queue << dep if in_degrees[dep] == 0
      end
    end
    result
  end

  def generate_in_degrees(update)
    dep_graph.each_with_object(Hash.new {|h,k| h[k] = 0 }) do |(a, deps), result|
      next unless update.include?(a)
      deps.each do |b|
        result[b] += 1 if update.include?(b)
      end
    end
  end

  def create_graph(deps)
    @dep_graph = deps.each_with_object(Hash.new {|h,k| h[k] = [] }) do |(a, b), result|
      result[a] << b
    end
  end
end

class TestPageOrderValidator < Minitest::Test
  def setup
    @validator = PageOrderValidator.new([%w(a b),%w(a c),%w(d e),%w(c d)])
  end

  def test_page_order_deps
    dep_graph = @validator.dep_graph
    assert(dep_graph.key?("a"))
    assert(dep_graph.key?("d"))
    refute(dep_graph.key?("h"))
    assert_equal(%w(b c), dep_graph["a"])
    assert_equal(%w(e), dep_graph["d"])
  end

  def test_validate
    assert(@validator.valid?(%w(a b c d e)))
    refute(@validator.valid?(%w(a b d e c)))
  end
end

def compute_correct_page_order_sum(deps, updates)
  validator = PageOrderValidator.new(deps)
  updates.filter do |update|
    validator.valid?(update)
  end.sum do |update|
    update[update.length/2].to_i
  end
end

def compute_incorrect_page_order_sum(deps, updates)
  validator = PageOrderValidator.new(deps)
  updates.reject do |update|
    validator.valid?(update)
  end.sum do |update|
    validator.fix_update(update)[update.length/2].to_i
  end
end


class TestSampleData < Minitest::Test
  attr_reader :deps, :updates, :validator
  def setup
    @deps, @updates = input_to_deps_and_updates(TEST)
    @validator = PageOrderValidator.new(@deps)
  end

  def test_sample_data_validation
    assert(validator.valid?(updates[0]))
    assert(validator.valid?(updates[1]))
    assert(validator.valid?(updates[2]))
    refute(validator.valid?(updates[3]))
    refute(validator.valid?(updates[4]))
    refute(validator.valid?(updates[5]))
  end

  def test_sample_data_result
    assert_equal(
      143,
      compute_correct_page_order_sum(deps, updates)
    )
  end

  def test_fix_update
    assert_equal(
      %w(97 75 47 61 53),
      validator.fix_update(%w(75 97 47 61 53))
    )
    assert_equal(
      %w(61 29 13),
      validator.fix_update(%w(61 13 29))
    )
    assert_equal(
      %w(97 75 47 29 13),
      validator.fix_update(%w(97 13 75 29 47))
    )
  end

  def test_sample_data_result_part_two
    assert_equal(
      123,
      compute_incorrect_page_order_sum(deps, updates)
    )
  end
end

class TestRealInput < Minitest::Test
  def test_real_input_part_one
    assert_equal(
      5268,
      compute_correct_page_order_sum(*input_to_deps_and_updates(REAL_INPUT))
    )
  end

  def test_real_input_part_two
    assert_equal(
      5799,
      compute_incorrect_page_order_sum(*input_to_deps_and_updates(REAL_INPUT))
    )
  end
end

puts(
  "RESULT part 1: #{compute_correct_page_order_sum(*input_to_deps_and_updates(REAL_INPUT))}"
)

puts(
  "RESULT part 2: #{compute_incorrect_page_order_sum(*input_to_deps_and_updates(REAL_INPUT))}"
)
