#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'

# Input is a list of point paths of rock structures.
input = ARGF.read.split("\n").map do |l|
  l.split(" -> ").map { |p| p.split(",").map &:to_i }
end

# PART 1
#
# Sand starts falling from point 500,0.
# How many grains of sand fit in the structure?

# build board with space around
dims = input.flatten(1).transpose.map &:minmax
YMAX = dims[1][1]

# using a precalculated width doesnt quite work for part 2
# so lets use a dynamicly expanding hash instead
board = Hash.new { |h, k| h[k] = [nil] * (YMAX+1) }

def between(a, b)
  a, b = [a, b].sort
  if a[0] == b[0] # vertical
    (a[1]..b[1]).map { |y| [a[0], y] }
  else # horizontal
    (a[0]..b[0]).map { |x| [x, a[1]] }
  end
end

def pb(board)
  board.sort.map(&:last).transpose.each do |row|
    puts row.map { |c|
      case c
      when '#'; c.light_black
      when 'S', 'o' ; c.light_yellow
      else ; '.'
      end
    }.join
  end
end

# calculate new sand position
def physics(board)
  sand = SAND_START.dup

  loop do
    return nil if sand[1] > board[sand[0]].size # overflow

    # try down, down-left, down-right
    if board[sand[0]][sand[1] + 1].nil?
      sand[1] += 1
    elsif board[sand[0] - 1][sand[1] + 1].nil?
      sand = [sand[0] - 1, sand[1] + 1]
    elsif board[sand[0] + 1][sand[1] + 1].nil?
      sand = [sand[0] + 1, sand[1] + 1]
    else # sand has settled
      break
    end
  end

  sand
end

SAND_START = [500, 0]

board[SAND_START[0]][SAND_START[1]] = 'S'

input.each do |path|
  path.each_cons(2) do |a, b|
    between(a, b).each do |point|
      board[point[0]][point[1]] = '#'
    end
  end
end

# pb board

pos = physics(board)
while pos
  board[pos[0]][pos[1]] = 'o'
  # pb board
  pos = physics(board)
end

puts board.values.flatten.count('o')

# PART 2
#
# Add a floor two layers after the lowest point.

# adjust "empty" columns to have the floor
board = Hash.new { |h, k| h[k] = [nil] * (YMAX+2) + ['#'] }

board[SAND_START[0]][SAND_START[1]] = 'S'

input.each do |path|
  path.each_cons(2) do |a, b|
    between(a, b).each do |point|
      board[point[0]][point[1]] = '#'
    end
  end
end

pos = physics(board)
until pos == SAND_START
  board[pos[0]][pos[1]] = 'o'
  # pb board
  pos = physics(board)
end

# pb board

puts board.values.flatten.count('o') + 1 # 'S'
