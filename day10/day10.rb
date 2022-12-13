#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'

# Input is a list of cpu instructions for a CRT communicator.
prog = ARGF.read.split("\n").map(&:split)

# PART 1
#
# Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles.
# What is the sum of these six signal strengths?

cycle = 0
x = 1
strengths = {}

prog.each do |op, arg|
  # check if need to save X at start of cycle
  cycle += 1
  strengths[cycle] = x * cycle if cycle % 40 == 20

  case op
  when 'noop'
    next
  when 'addx'
    # check if need to save X at start of second cycle
    cycle += 1
    strengths[cycle] = x * cycle  if cycle % 40 == 20

    # only update at end of second cycle
    x += arg.to_i
  end
end

# p strengths
# strengths.each { |c, x| puts "#{c}: #{x}" }

puts "Part 1: #{strengths.values.sum}"

# PART 2
#
# The signal strength is the position of a 1.3 sprite on a 40x6 display.
# What eight capital letters appear on your CRT?

cycle = 0
x = 1
display = ['.'.light_black] * (40 * 6)

prog.each do |op, arg|
  cycle = (cycle + 1) % (40 * 6)
  display[cycle - 1] = '#'.on_red if (x..x+2).include?(cycle % 40)

  case op
  when 'noop'
    next
  when 'addx'
    cycle = (cycle + 1) % (40 * 6)
    display[cycle - 1] = '#'.on_red if (x..x+2).include?(cycle % 40)

    # only update at end of second cycle
    x += arg.to_i
  end
end

puts "Part 2:"
puts display.each_slice(40).map(&:join).join("\n")
