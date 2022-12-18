#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rgl'
end

require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/traversal'
require 'rgl/dijkstra'

# Input is a heightmap of elevations from a-z.
input = ARGF.read.split("\n").map { |l| l.chars }

# PART 1
#
# Find the shortest path from S to E, moving up at most one unit at a time.

map = RGL::DirectedAdjacencyGraph.new

def key(i,j)
  "#{i}-#{j}"
end

# transform letters into heights, and handle start and end points
heights = input.map.with_index do |row, i|
  row.map.with_index do |point, j|
    case point
    when 'S'
      map.add_edge('START', key(i,j))
      'a'.ord
    when 'E'
      map.add_edge(key(i,j), 'END')
      'z'.ord
    else
      point.ord
    end
  end
end

# build graph of possible paths between points
heights.each_with_index do |row, i|
  row.each_with_index do |point, j|
    # calc adjacency to cardinal directions
    [
      ([i-1,j, heights[i - 1][j]] if i - 1 >= 0), # U
      ([i+1,j, heights[i + 1][j]] if i + 1 < heights.size), # D
      ([i,j-1, heights[i][j - 1]] if j - 1 >= 0), # L
      ([i,j+1, heights[i][j + 1]] if j + 1 < row.size), # R
    ].compact.each do |ai, aj, adj_p|
      if point + 1 >= adj_p
        map.add_edge(key(i,j), key(ai,aj))
      end
    end
  end
end

# djikstras to find shortest path
# - 3 to compoensate for added STARt/END nodes
puts map.dijkstra_shortest_path(Hash.new(1), 'START', 'END').size - 3

# PART 2
#
# Find the shortest path out of any starting point at elevation 'a',

# add all 'a' points as starting
heights.each_with_index do |row, i|
  row.each_with_index do |point, j|
    map.add_edge('START', key(i,j)) if point == 'a'.ord
  end
end

# djikstras to find shortest path
# - 3 to compoensate for added STARt/END nodes
puts map.dijkstra_shortest_path(Hash.new(1), 'START', 'END').size - 3
