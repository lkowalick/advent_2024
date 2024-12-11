#!/usr/bin/env ruby

require "minitest/autorun"

FILENAME = "./day10_input.txt"

real_data = "27 10647 103 9 0 5524 4594227 902936"
test_data = "125 17"

def parse_input(text)
  text.scan(/\d+/).map(&:to_i)
end

def evolve(list)
  list.each_with_object([]) do |elt, new_list|
    if elt == 0
      new_list << 1
    elsif elt.to_s.length.even?
      new_list << elt.to_s[0,elt.to_s.length/2].to_i << elt.to_s[elt.to_s.length/2,elt.to_s.length/2].to_i
    else
      new_list << elt * 2024
    end
  end
end

def evolve_n(list, n)
  result = list
  n.times { result = evolve(result) }
  result
end

def stone_count_after_n_evolutions(list, n)
  evolve_n(list, n).length
end

Class.new(Minitest::Test) do
  define_method :test_parse_input do
    assert_equal([125, 17], parse_input(test_data))

    assert_equal(
      [27, 10647, 103, 9, 0, 5524, 4594227, 902936],
      parse_input(real_data),
    )
  end

  define_method :test_evolve do
    assert_equal(
      [253000,1,7],
      evolve(parse_input(test_data))
    )
    assert_equal(
      [253,0,2024,14168],
      evolve(evolve(parse_input(test_data)))
    )
    assert_equal(
      [512072,1,20,24,28676032],
      evolve(evolve(evolve(parse_input(test_data))))
    )
  end

  define_method :test_stone_count_after_n_evolutions do
    assert_equal(
      22,
      stone_count_after_n_evolutions(parse_input(test_data), 6)
    )
    assert_equal(
      55312,
      stone_count_after_n_evolutions(parse_input(test_data), 25)
    )
    assert_equal(
      229043,
      stone_count_after_n_evolutions(parse_input(real_data), 25)
    )
  end
end
