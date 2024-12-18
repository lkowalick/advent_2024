#!/usr/bin/env ruby

#part 1
list1, list2 = [], []
File.read("./day1_input.txt").each_line do |line|
  item1, item2 = line.scan(/\d+/).map(&:to_i)
  list1 << item1
  list2 << item2
end

list1.sort!
list2.sort!

total_distance = list1.zip(list2).reduce(0) do |acc, (item1, item2)|
  acc += (item1 - item2).abs
end

puts "TOTAL DISTANCE: #{total_distance}"

list1_counts = list1.tally
list2_counts = list2.tally

similarity_score = list1_counts.reduce(0) do |acc, (loc_id, count)|
  next(acc) unless list2_counts.include?(loc_id)

  acc += count * loc_id * list2_counts[loc_id]
end

puts "SIMILARITY SCORE: #{similarity_score}"
