#!/usr/bin/env ruby
# frozen_string_literal: true
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rgl'
end

require 'matrix'

require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/traversal'

# Input is a heightmap of a forest.
# Trees are visible if all trees between it and an edge are shorter.
map = ARGF.read.split("\n").map { |l| l.chars.map(&:to_i) }

# use a class instead of a int primitive to avoid primitive singleton dedup
class Node
  attr_accessor :height, :label, :x, :y

  def initialize(height, xpos = nil, ypos = nil, label = 'Tree')
    @height = height
    @label = label
    @x = xpos
    @y = ypos
  end

  def to_s
    "<#{@label}##{x},#{y}: #{@height}>"
  end
end

trees = Matrix[*map.map.with_index { |r, i| r.map.with_index { |h, j| Node.new(h, i, j) } }]

puts "matrix built"

# PART 1
#
# How many trees are visible from outside the grid?

# build visiblity graph from map
visg = RGL::DirectedAdjacencyGraph.new

outside = Node.new(-1, nil, nil, 'outside')
# trees.map { |t| visg.add_vertex(t) }

# add all outside trees as visible
[
  *trees.row(0),
  *trees.row(-1),
  *trees.column(0),
  *trees.column(-1)
].map { |t| visg.add_edge(outside, t) }

# map over inner trees
# outside = Node.new(-1, 'outside')
# trees.each_with_index do |t, r, c|
#   left  = r > 0 ? trees[r-1, c] : outside
#   right = r < trees.row_count ? trees[r+1, c] : outside
#   up    = c > 0 ? trees[r, c-1] : outside
#   down  = r < trees.column_count ? trees[r, c+1] : outside

#   visg.add_edge(left, t) if left.height >
# end

dirs = (trees.row_vectors[1..-2] + trees.column_vectors[1..-2])

(dirs + dirs.map(&:reverse_each)).each do |dir_vector|
  dir_vector.reduce do |tallest, tree|
    if tree.height > tallest.height
      visg.add_edge(tallest, tree)

      tree
    else
      tallest
    end
  end
end

puts "graph built"

visg.write_to_graphic_file('png')

puts "Part 1: #{visg.count - 1}" # don't count Outside node
