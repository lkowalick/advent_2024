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
    program_output.join(",")
  end

  def execute_with_short_circuit
    while ip + 1 < instructions.length
      execute_instruction(*instructions[ip,2])
    end
    puts "PROGRAM_OUTPUT: #{program_output}"
    false
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
      Machine.new(Debugger.new(10,0,0,[5,0,5,1,5,4])).execute
    )
    assert_equal(
      "4,2,5,6,7,7,7,7,3,1,0",
      Machine.new(Debugger.new(2024,0,0,[0,1,5,4,3,0])).execute
    )
    assert_equal(
      "4,6,3,5,6,3,5,2,1,0",
      Machine.new(Debugger.new(729,0,0,[0,1,5,4,3,0])).execute
    )
    assert_equal(
      "2,1,3,0,5,2,3,7,1",
      Machine.new(real_data).execute
    )
  end

  define_method :test_execute_with_short_circuit do
    assert(
                                                                                     Machine.new(Debugger.new(117440,0,0,[0,3,5,4,3,0])).execute_with_short_circuit
    )
    refute(
                                                                                 Machine.new(Debugger.new(20,0,0,[0,3,5,4,3,0])).execute_with_short_circuit
    )
  end
end

def find_a
  [
0303307501442463,
0303307501472463,
0303307511026463,
0303307511326463,
0303307511422463,
0303307511426463,
0303307511442463,
0303307511472463,
0303307701442463,
0303307701472463,
0305647501442463,
0305647501472463,
0305647511026463,
0305647511326463,
0305647511422463,
0305647511426463,
0305647511442463,
0305647511472463,
0305647701442463,
0305647701472463,
0315047501442463,
0315047501472463,
0315047511026463,
0315047511326463,
0315047511422463,
0315047511426463,
0315047511442463,
0315047511472463,
0315047701442463,
0315047701472463,
0315647501442463,
0315647501472463,
0315647511026463,
0315647511326463,
0315647511422463,
0315647511426463,
0315647511442463,
0315647511472463,
0315647701442463,
0315647701472463,
].each do |i|
  a = i * 8
  0.upto(7).each do |inc|
    num = a + inc
    print "RUNNING WITH 0#{num.to_s(8)}, "
    Machine.new(Debugger.new(num, 0, 0, [2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0])).execute_with_short_circuit
  end
end
end

#print_instructions([2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0])
find_a
