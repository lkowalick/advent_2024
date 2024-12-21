#!/usr/bin/env ruby

require "minitest/autorun"
require "algorithms"

REAL_DATA = %w(319A 985A 340A 489A 964A)

TEST_DATA = %w(029A 980A 179A 456A 379A)


class EntryPad
  attr_accessor :position, :moves
  def initialize
    @position = self.class.start_position
    @moves = []
  end

  def enter(entry)
    new_position = self.class.entries.fetch(entry)
    di = new_position.first - position.first
    dj = new_position.last - position.last

    moves.concat(%w(>) * dj.abs) if dj > 0
    moves.concat(%w(v) * di.abs) if di > 0
    moves.concat(%w(^) * di.abs) if di < 0
    moves.concat(%w(<) * dj.abs) if dj < 0
    moves << "A"

    self.position = new_position
    moves
  end
end

class NumPad < EntryPad
  #   7   8   9
  #   4   5   6
  #   1   2   3
  #       0   A
  #
  #  Go up before going left
  #  decrement i before decrementing j
  #  Go right before going down
  #  increment j before incrementing i
  class << self
    def entries
      {
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
    end

    def start_position
      [3,2]
    end
  end
end

class ArrowKeys < EntryPad
  #       ^   A
  #   <   v   >
  #
  #  Go right before going up
  #  increment j before decrementing i
  #  Go down before going left
  #  increment i before decrementing j

  class << self
    def entries
      {
        "^" => [0,1],
        "A" => [0,2],
        "<" => [1,0],
        "v" => [1,1],
        ">" => [1,2],
      }
    end

    def start_position
      [0,2]
    end
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

