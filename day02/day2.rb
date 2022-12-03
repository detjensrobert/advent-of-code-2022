#!/usr/bin/env ruby

# Scoring values
ROCK = 1
PAPER = 2
SCISSORS = 3
LOSS = 0
DRAW = 3
WIN = 6

# Input is a rock paper scissors strategy guide
input = ARGF.read.split

# A/X for rock, B/Y paper, C/Z scissors.
moves = input.map do |m|
  case m
  in 'A' | 'B' | 'C'
    m.ord - 'A'.ord + 1
  in 'X' | 'Y' | 'Z'
    m.ord - 'X'.ord + 1
  end
end

# Part 1
# What is the end score of all the matches?
score = moves.each_slice(2).map do |op, me|
  case [op, me]
  in [ROCK, PAPER] | [PAPER, SCISSORS] | [SCISSORS, ROCK]
    me + WIN
  in [ROCK, SCISSORS] | [PAPER, ROCK] | [SCISSORS, PAPER]
    me + LOSS
  in [ROCK, ROCK] | [PAPER, PAPER] | [SCISSORS, SCISSORS]
    me + DRAW
  end
end

puts "Part 1: #{score.sum}"

# PART 2
#
# X/Y/Z is now the desired outcome instead of a move. (Lose/Draw/Win)
# What's the score now?

moves = input.map do |m|
  case m
  in 'A' | 'B' | 'C'
    m.ord - 'A'.ord + 1
  in 'X' | 'Y' | 'Z'
    (m.ord - 'X'.ord) * 3
  end
end

score = moves.each_slice(2).map do |op, outcome|
  case [op, outcome]
  in [ROCK, WIN] | [PAPER, DRAW] | [SCISSORS, LOSS]
    outcome + PAPER
  in [ROCK, DRAW] | [PAPER, LOSS] | [SCISSORS, WIN]
    outcome + ROCK
  in [ROCK, LOSS] | [PAPER, WIN] | [SCISSORS, DRAW]
    outcome + SCISSORS
  end
end

puts "Part 2: #{score.sum}"
