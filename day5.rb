#!/usr/bin/env ruby

require "minitest/autorun"
FILENAME = "./day5_input.txt"

real_input = File.read(FILENAME)

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

