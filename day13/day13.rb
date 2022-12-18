#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

# Input is pairs of integer arrays
input = ARGF.read.split("\n\n").map do|chunk|
  chunk.split("\n").map { |l| JSON.load l }
end

# PART 1
#
# What is the sum of the indexes of packet pairs in the right order?

# coalese int/arr comparisons to arr/arr
module SpaceshipCoalece
  def <=>(other)
    case [self, other]
    in Integer, Array
      [self] <=> other
    in Array, Integer
      self <=> [other]
    else
      super
    end
  end
end

class Integer
  prepend SpaceshipCoalece
end

class Array
  prepend SpaceshipCoalece
end

puts input.map {|a, b| a <=> b } # compare each pair
          .each.with_index       # if b was larger (1), dont add to sum
          .reduce(0) { |sum, (res, i)| res == 1 ? sum : i + 1 + sum }

# PART 2
#
#
