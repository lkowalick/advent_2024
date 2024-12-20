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

  inventory = inventory_text.scan(/\w+/).sort_by(&:length)

  patterns = patterns_text.each_line.map { |l| l.chomp }.sort_by(&:length)

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

def sum_ways(parsed_input)
  parsed_input => { inventory:, patterns: }
  cache = Hash.new(0)
  cache[""] = 1
  backwards_inventory_trie = {}

  inventory.each do |inv|
    node = backwards_inventory_trie
    inv.reverse.each_char do |char|
      node[char] ||= {}
      node = node[char]
    end
    node[:match] = true
  end

  patterns.sum { |p| num_ways(p, backwards_inventory_trie, cache) }
end

def num_ways(pattern, backwards_inventory_trie, cache)
  return cache[pattern] if cache.key?(pattern)
  i = 0
  node = backwards_inventory_trie
  while i < pattern.length do
    i += 1
    node = node[pattern[-i]]
    break unless node
    cache[pattern] += num_ways(pattern[0...-i], backwards_inventory_trie, cache) if node[:match]
  end
  cache[pattern]
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(%w(r wr b g bwu rb gb br).sort_by(&:length), parse_input(test_data)[:inventory].to_a)
    assert_equal(%w(brwrr bggr gbbr rrbgbr ubwu bwurrg brgr bbrgwb).sort_by(&:length), parse_input(test_data)[:patterns])
  end

  define_method :test_num_possible_patterns do
    assert_equal(6, num_possible_patterns(parse_input(test_data)))
    assert_equal(242, num_possible_patterns(parse_input(real_data)))
  end

  define_method :test_sum_ways do
    assert_equal(16, sum_ways(parse_input(test_data)))
    assert_equal(595_975_512_785_325, sum_ways(parse_input(real_data)))
  end
end

