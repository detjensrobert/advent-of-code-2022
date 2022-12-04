#!/usr/bin/env ruby

# Input is range pairs
input = ARGF.read.split.map do |line| # split input into lines
  line.split(',').map do |r|          # split each line into each range pair
    r.match(/(\d+)-(\d+)/).captures   # parse dash syntax into start and end
      .map(&:to_i)                    # convert strings to numbers
  end.map { |s, e| (s..e) }           # turn start/end numbers into ruby ranges
end

# PART 1
#
# How many ranges fully contain the other?
puts input.count { |a, b| a.cover?(b) || b.cover?(a) }

# PART 1
#
# How many ranges overlap at all?
class Range
  def overlaps?(other)
    include?(other.first) || other.include?(first)
  end
end

puts input.count { |a, b| a.overlaps?(b) }
