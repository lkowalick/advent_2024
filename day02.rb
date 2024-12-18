#!/usr/bin/env ruby

# a report is safe if both of the following are true
# - the levels are either all increasing or all decreasing (monotonic)
# - adjacent levels differ by at least one and at most three


reports = []
File.read("./day2_input.txt").each_line do |line|
  reports << line.scan(/\d+/).map(&:to_i)
end

def safe_wo_removal?(report)
  inc = if (report[1] - report[0]) > 0
          true
        elsif (report[1] - report[0]) < 0
          false
        else
          return false
        end
  report.each_cons(2).all? do |a, b|
    if inc
      (b-a) >= 1 && (b-a) <= 3
    else
      (a-b) >= 1 && (a-b) <= 3
    end
  end
end

safe_reports_part1 = reports.count do |report|
  safe_wo_removal?(report)
end

safe_reports_part2 = reports.count do |report|
  next(true) if safe_wo_removal?(report)

  report.each_index.any? do |i|
    safe_wo_removal?(report[0...i] + report[i+1..])
  end
end

puts "SAFE REPORTS part1: #{safe_reports_part1}"
puts "SAFE REPORTS part2: #{safe_reports_part2}"
