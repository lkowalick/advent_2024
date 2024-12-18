#!/usr/bin/env ruby

FILENAME = "./day3_input.txt"

muls = File.read(FILENAME).scan(/mul\(\d+,\d+\)/)

multiplcations = muls.reduce(0) do |acc, mul|
  acc + mul.scan(/\d+/).map(&:to_i).reduce(:*)
end

puts "MULTIPLICATIONS part 1: #{multiplcations}"

test = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

DO = "do()"
DONT = "don't()"
MUL = /mul\(\d+,\d+\)/

def tokenize(inst_string)
  inst_string.scan(Regexp.union(DO,DONT,MUL))
end

def enabled_multiplications(tokenized_instructions)
  read_muls = true
  tokenized_instructions.reduce(0) do |acc, instruction|
    case instruction
    when MUL
      next(acc) unless read_muls
      acc + instruction.scan(/\d+/).map(&:to_i).reduce(:*)
    else
      read_muls = DO === instruction
      acc
    end
  end
end

test_enabled_multiplications = enabled_multiplications(tokenize(test))

puts "TEST enabled_multiplications #{test_enabled_multiplications} should be 48"

multiplications_p2 = enabled_multiplications(tokenize(File.read(FILENAME)))

puts "MULTIPLCATIONS part 2: #{multiplications_p2}"

