#!/usr/bin/env ruby

require "minitest/autorun"
require "algorithms"

REAL_DATA = %w(319A 985A 340A 489A 964A)

TEST_DATA = %w(029A 980A 179A 456A 379A)

class NumPad
  #   7   8   9
  #   4   5   6
  #   1   2   3
  #       0   A
  #
  #  Go up before going left
  #  decrement i before decrementing j
  #  Go right before going down
  #  increment j before incrementing i
  ENTRIES = {
    "7" => [0,0],
    "8" => [0,1],
    "9" => [0,2],
    "4" => [1,0],
    "5" => [1,1],
    "6" => [1,2],
    "1" => [2,0],
    "2" => [2,1],
    "3" => [2,2],
    "0" => [3,1],
    "A" => [3,2],
  }

  attr_accessor :position, :moves
  def initialize
    @position = [3,2]
    @moves = []
  end

  def enter(entry)
    new_position = ENTRIES.fetch(entry)
    di = new_position.first - position.first
    dj = new_position.last - position.last

    self.moves += %w(>) * dj.abs if dj > 0
    self.moves += %w(v) * di.abs if di > 0
    self.moves += %w(^) * di.abs if di < 0
    self.moves += %w(<) * dj.abs if dj < 0
    self.moves << "A"

    self.position = new_position
    moves
  end
end

class TestCode < Minitest::Test
  def test_moving_on_numpad
    numpad = NumPad.new
    assert_equal(%w(< A), numpad.enter("0"))
    assert_equal(%w(< A ^ A), numpad.enter("2"))
    assert_equal(%w(< A ^ A > ^ ^ A), numpad.enter("9"))
    assert_equal(%w(< A ^ A > ^ ^ A v v v A), numpad.enter("A"))
  end
end

