#!/usr/bin/env ruby
# frozen_string_literal: true

# Input is a diagram of container stacks
# and a list of move operations on those
diagram, moves = ARGF.read.split("\n\n")

moves = moves.split("\n").map do |s|
  count, src, dest = s.match(/move (\d+) from (\d+) to (\d+)/).captures
  # decrement the indexes since stack names are 1-indexed
  { src: src.to_i - 1, dest: dest.to_i - 1, count: count.to_i }
end

# PART 1
#
# What crates end up on the top of the stacks?

# extract values from stack diagram
# each stack is 4 chars wide, value is the second char
stacks = diagram.split("\n").map { |row| row.chars.each_slice(4).map { |s| s[1] } }

# parse diagram into 2d array
stack_count = stacks.last.size
stacks = stacks[..-2]                               # discard last row (labels)
  .map { |r| r + ([' '] * (stack_count - r.size)) } # ensure each row is as wide as the others
  .transpose.map(&:reverse)                         # transpose so stacks line up with array access
  .map { |col| col.reject { |e| e == ' ' } }        # remove blank entries

fresh_stacks = stacks.map(&:dup) # take copy of initial stacks for part 2

moves.each do |m|
  # move :src -> :dest, :count number of times
  m[:count].times { stacks[m[:dest]].append(*stacks[m[:src]].pop) }
end

puts "Part 1: #{stacks.map(&:last).join}"

# PART 2
#
# Movements happen at once rather than one at a time.
# What crates end up on the top of the stacks?
stacks = fresh_stacks

moves.each do |m|
  # move :count elements from :src -> :dest at once
  stacks[m[:dest]].append(*stacks[m[:src]].pop(m[:count]))
end

puts "Part 2: #{stacks.map(&:last).join}"
