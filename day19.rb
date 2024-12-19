#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day19_input.txt"

real_data = File.read(FILENAME)

test_data = <<~TEST.chomp
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
TEST

def parse_input(input)
  inventory_text, patterns_text = input.split("\n\n")

  inventory = Set.new(inventory_text.scan(/\w+/))

  patterns = patterns_text.each_line.map { |l| l.chomp }

  { inventory:, patterns: }
end

def num_possible_patterns(parsed_input)
  parsed_input => { inventory:, patterns: }
  cache = { "" => true }
  inventory.each { |inv| cache[inv] = true }

  patterns.count { |p| pattern_possible?(p, cache) }
end

def pattern_possible?(pattern, cache)
  unless cache.key?(pattern)
    cache[pattern] = 1.upto(pattern.length - 1).any? do |i|
      pattern_possible?(pattern[0...i], cache) && pattern_possible?(pattern[i..], cache)
    end
  end
  cache.fetch(pattern)
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(%w(r wr b g bwu rb gb br), parse_input(test_data)[:inventory].to_a)
    assert_equal(%w(brwrr bggr gbbr rrbgbr ubwu bwurrg brgr bbrgwb), parse_input(test_data)[:patterns])
  end

  define_method :test_num_possible_patterns do
    assert_equal(6, num_possible_patterns(parse_input(test_data)))
    assert_equal(242, num_possible_patterns(parse_input(real_data)))
  end
end

