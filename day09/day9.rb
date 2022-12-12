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

def print_map(visited, head, tail)
  # find coordinate dimensions
  dims_x, dims_y = (visited + [head, tail].compact).to_a
    .transpose.map{ |dim| Vector[*dim.minmax.sort] }

  # adjust all coordinates to be positive
  adj = Vector[(0 - dims_x[0]).clamp(0..), (0 - dims_y[0]).clamp(0..)]

  dims_x += adj
  dims_y += adj
  visited_adj = visited.map { |v| v + adj }
  head += adj
  tail += adj

  # create map matrix
  map = Matrix.build(dims_x[1] + 1, dims_y[1] + 1) { ' ' }

  # add points to map
  visited_adj.each { |v| map[*v.to_a] = ' '.on_light_black }
  map[0, 0] = 's'.white.on_light_black
  map[*tail.to_a] = 'T'.on_light_red
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

# print_map(positions, head, tail)

moves.each do |dir, dist|
  dist.times do
    # puts "moving #{dir}"
    head += DIRS[dir]
    delta = head - tail

    # puts " pos delta: #{delta}"

    case delta
    in [(-1..1), (-1..1)] # not far enough away
      # puts "  no movement"
    else # catch up, one king's move at a time
      tail += Vector[ *delta.map { |c| c.clamp(-1, 1) } ]
      positions << tail
      # puts "  catching up"
      # puts "    clamped delta: #{delta.map { |c| c.clamp(-1, 1) }}"
      # puts "    new tail pos: #{tail}"
    end

    # print_map(positions, head, tail)
    # sleep 0.25
  end
end

print_map(positions, head, tail)

puts "Part 1: #{positions.size} visited spots"
