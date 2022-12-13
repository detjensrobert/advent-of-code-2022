#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'colorize'
end

require 'matrix'
require 'set'
require 'colorize'

# Input is a list of directions to move a short rope.
# The tail of the rope always catches up to the head if it gets too far away.
moves = ARGF.read.split("\n").map { |l| d, c = l.split; [d.to_sym, c.to_i] }

# PART 1
#
# How many positions does the rope tail visit at least once?

# add implict conversion of vector to array
class Vector
  def to_ary; to_a; end
  def deconstruct; to_a; end
end

def print_map(visited, head, tails)
  # find coordinate dimensions
  dims_x, dims_y = (visited + [head] + tails).to_a
    .transpose.map{ |dim| Vector[*dim.minmax.sort] }

  # adjust all coordinates to be positive
  adj = Vector[(0 - dims_x[0]).clamp(0..), (0 - dims_y[0]).clamp(0..)]

  dims_x += adj
  dims_y += adj
  visited_adj = visited.map { |v| v + adj }
  head += adj
  tails_adj = tails.map { |t| t + adj }

  # create map matrix
  map = Matrix.build(dims_x[1] + 1, dims_y[1] + 1) { ' ' }

  # add points to map
  visited_adj.each { |v| map[*v.to_a] = ' '.on_light_black }
  map[0, 0] = 's'.white.on_light_black
  tails_adj.each_with_index { |t, i| map[*t.to_a] = (i+1).to_s.red.on_light_black }
  map[*head.to_a] = 'H'.on_light_blue

  # print matrix
  puts "MAP:"
  map.column_vectors.reverse.each { |x| puts x.to_a.join }
end

DIRS = {
  U: Vector[0,1],
  D: Vector[0,-1],
  L: Vector[-1,0],
  R: Vector[1,0],
}

tail = head = Vector[0, 0]
positions = Set[tail]

moves.each do |dir, dist|
  dist.times do
    head += DIRS[dir]
    delta = head - tail

    # far enough away?
    unless delta in [(-1..1), (-1..1)]
      # catch up, one king's move at a time
      tail += Vector[ *delta.map { |c| c.clamp(-1, 1) } ]
      positions << tail
    end
  end
end

# print_map(positions, head, [tail])

puts "Part 1: #{positions.size} visited spots"

# PART 2
#
# Now there are 10 rope knots that all follow the previous one.
# How many positions does the rope tail (last knot) visit at least once?

head = Vector[0, 0]
tails = [Vector[0,0]] * 9
positions = Set[tails.last]

moves.each do |dir, dist|
  dist.times do
    head += DIRS[dir]

    # cant use map here since we need to change values during iterations
    tails.each_with_index do |t, i|
      prev = i == 0 ? head : tails[i - 1]
      delta = prev - t

      # not far enough away?
      next if delta in [(-1..1), (-1..1)]

      # catch up, one king's move at a time
      # move each tail to catch up with the one before it
      tails[i] = t + Vector[ *delta.map { |c| c.clamp(-1, 1) } ]
    end

    positions << tails.last
  end
end

# print_map(positions, head, tail)

puts "Part 2: #{positions.size} visited spots"
