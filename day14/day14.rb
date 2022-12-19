#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'colorize'
require 'debug'

# Input is a list of point paths of rock structures.
input = ARGF.read.split("\n").map do |l|
  l.split(" -> ").map { |p| p.split(",").map &:to_i }
end

# PART 1
#
# Sand starts falling from point 500,0.
# How many grains of sand fit in the structure?

# find bounds of structures and offset for sane indexing
xoffset = input.flatten(1).map(&:first).min - 1
input.map! { |path| path.map { |p| [p[0] - xoffset, p[1]] } }

SAND_START = [500 - xoffset, 0]

# build board with space around
DIMS = input.flatten(1).transpose.map { |dim| dim.max + 2 }
board = Matrix.build(*DIMS) { nil }

def between(a, b)
  a, b = [a, b].sort
  if a[0] == b[0] # vertical
    (a[1]..b[1]).map { |y| [a[0], y] }
  else # horizontal
    (a[0]..b[0]).map { |x| [x, a[1]] }
  end
end

board[*SAND_START] = 'S'

input.each do |path|
  path.each_cons(2) do |a, b|
    between(a, b).each do |point|
      board[*point] = '#'
    end
  end
end

def pb(board)
  board.column_vectors.map do |r|
    puts r.to_a.map { |c|
      case c
      when '#'; c.light_black
      when 'S', 'o' ; c.light_yellow
      else ; '.'
      end
    }.join
  end
end

# pb board

# calculate new sand position
def physics(board)
  sand = SAND_START.dup

  loop do
    return nil if sand[1] + 1 == DIMS[1] # overflow

    # try down, down-left, down-right
    if board[ sand[0], sand[1] + 1 ].nil?
      sand[1] += 1
    elsif board[ sand[0] - 1, sand[1] + 1 ].nil?
      sand = [sand[0] - 1, sand[1] + 1]
    elsif board[ sand[0] + 1, sand[1] + 1 ].nil?
      sand = [sand[0] + 1, sand[1] + 1]
    else # sand has settled
      break
    end
  end

  sand
end

pos = physics(board)
while pos
  # puts "new sand pos: #{pos}"
  board[*pos] = 'o'
  # pb(board)
  pos = physics(board)
end

puts board.map.count('o')

# PART 2
#
#
