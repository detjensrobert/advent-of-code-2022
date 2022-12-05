#!/usr/bin/env ruby
# frozen_string_literal: true

# Input is elf rucksacks with two compartments
sacks = ARGF.read.split.map(&:chars)
PRIORITIES = ['_'] + ('a'..'z').to_a + ('A'..'Z').to_a

# PART 1
#
# What is the priorities sum of items in both halves of each rucksack?
puts sacks.map { |s| s.each_slice(s.size / 2).to_a }
  .map { |front, back| (front & back).first }
  .map { |common| PRIORITIES.index(common) }.sum

# PART 2
#
# Elves are in groups of three. Find the sum of priorities for items common to all three rucksacks.
puts sacks.each_slice(3)
  .map { |group| group.reduce(&:intersection).first }
  .map { |badge| PRIORITIES.index(badge) }.sum
