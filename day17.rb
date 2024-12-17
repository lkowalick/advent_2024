#!/usr/bin/env ruby

require "minitest/autorun"

Debugger = Struct.new(:a,:b,:c,:program)
real_data = Debugger.new(47792830, 0, 0, [2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0])

def output(program)
  "0,1,2"
end

Class.new(Minitest::Test) do
  define_method :test_evaluate do
    assert_equal(
      "0,1,2",
      output(
        Debugger.new(10,0,0,[5,0,5,1,5,4]),
      ),
    )
    assert_equal("0,1,2",output(Debugger.new(2024,0,0,[0,1,5,4,3,0])))
    assert_equal("4,6,3,5,6,3,5,2,1,0",output(Debugger.new(729,0,0,[0,1,5,4,3,0])))
  end
end
