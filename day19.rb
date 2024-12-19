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
  inventory = inventory_text.scan(/\w+/)
  patterns = patterns_text.each_line.map { |l| l.chomp }
  { inventory:, patterns: }
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal(%w(r wr b g bwu rb gb br), parse_input(test_data)[:inventory])
    assert_equal(%w(brwrr bggr gbbr rrbgbr ubwu bwurrg brgr bbrgwb), parse_input(test_data)[:patterns])
  end
end
