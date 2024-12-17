#!/usr/bin/env ruby

require "minitest/autorun"

Debugger = Struct.new(:a,:b,:c,:instructions)
real_data = Debugger.new(47792830, 0, 0, [2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0])

ADV = 0
BXL = 1
BST = 2
JNZ = 3
BXC = 4
OUT = 5
BDV = 6
CDV = 7

class Machine
  attr_accessor :a, :b, :c, :ip, :program_output
  attr_reader :instructions
  def initialize(debugger)
    @a = debugger.a
    @b = debugger.b
    @c = debugger.c
    @instructions = debugger.instructions
    @ip = 0
    @program_output = []
  end

  def execute
    while ip + 1 < instructions.length
      execute_instruction(*instructions[ip,2])
    end
    program_output
  end

  def to_state
    [a,b,c,ip,program_output]
  end

  def execute_instruction(ins, operand)
    case ins
    when ADV
      self.a /= 2**get_combo_operand(operand)
      self.ip += 2
    when BXL
      self.b ^= operand
      self.ip += 2
    when BST
      self.b = get_combo_operand(operand) % 8
      self.ip += 2
    when JNZ
      self.ip = if a.zero?
                  ip + 2
                else
                  operand
                end
    when BXC
      self.b ^= c
      self.ip += 2
    when OUT
      self.program_output << get_combo_operand(operand) % 8
      self.ip += 2
    when BDV
      self.b = a / 2**get_combo_operand(operand)
      self.ip += 2
    when CDV
      self.c = a / 2**get_combo_operand(operand)
      self.ip += 2
    else
      raise "UNKNOWN INSTRUCTION #{ins}"
    end
  end

  def get_combo_operand(operand)
    case operand
    when (0..3)
      operand
    when 4
      a
    when 5
      b
    when 6
      c
    else
      raise "INVALID COMBO OPERAND #{operand}"
    end
  end
end

def print_instructions(instructions)
  combos = [0,1,2,3,"A","B","C"]
  instructions.each_slice(2) do |ins, operand|
    case ins
    when ADV
      puts "A = A / 2**#{combos[operand]}"
    when BXL
      puts "B = B ^ #{operand}"
    when BST
      puts "B = #{combos[operand]} % 8"
    when JNZ
      puts "JUMP TO #{operand} if A != 0"
    when BXC
      puts "B = B ^ C"
    when OUT
      puts "OUTPUT <<  #{combos[operand]} % 8"
    when BDV
      puts "B = A / 2**#{combos[operand]}"
    when CDV
      puts "C = A / 2**#{combos[operand]}"
    else
      raise "UNKNOWN INSTRUCTION #{ins}"
    end
  end
end

Class.new(Minitest::Test) do
  define_method :test_evaluate do
    assert_equal(
      "0,1,2",
      Machine.new(Debugger.new(10,0,0,[5,0,5,1,5,4])).execute.join(",")
    )
    assert_equal(
      "4,2,5,6,7,7,7,7,3,1,0",
      Machine.new(Debugger.new(2024,0,0,[0,1,5,4,3,0])).execute.join(",")
    )
    assert_equal(
      "4,6,3,5,6,3,5,2,1,0",
      Machine.new(Debugger.new(729,0,0,[0,1,5,4,3,0])).execute.join(",")
    )
    assert_equal(
      "2,1,3,0,5,2,3,7,1",
      Machine.new(real_data).execute.join(",")
    )
  end


  define_method :test_find_a do
    assert_equal(107416732707226, find_a)
  end
end

def find_a
  instructions = [2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0]
  nums = Array.new(18) { [] }
  nums[1] << 0
  1.upto(16).each do |i|
    nums[i].each do |base|
      a = base * 8
      0.upto(7).each do |inc|
        num = a + inc
        if Machine.new(Debugger.new(num, 0, 0, instructions)).execute == instructions[-i..]
          nums[i+1] << num
        end
      end
    end
  end
  nums[17].min
end
