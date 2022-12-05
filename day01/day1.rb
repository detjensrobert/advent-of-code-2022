#!/usr/bin/env ruby
# frozen_string_literal: true

# Input is a list of elves, separated by double newlines
# Each elf has a list of calorie counts of the food they are carrying.
input = ARGF.read.split("\n\n").map { |elf| elf.split("\n").map(&:to_i) }

# PART 1
#
# How many calories is the elf with the maximum number of calories carrying?
puts "Part 1: max calories: #{input.map(&:sum).max}"

# PART 2
#
# What is the sum of the top three elves calories?
puts "Part 2: Sum of top three: #{input.map(&:sum).sort[-3..].sum}"

# golfed: 110 chars
# rubocop:disable all
input=ARGF.read.split("\n\n").map{|e|e.split("\n").map &:to_i}.map(&:sum).sort
puts input.last,input[-3..].sum
