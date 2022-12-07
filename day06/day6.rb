#!/usr/bin/env ruby
# frozen_string_literal: true

# Input is a datastream.
stream = ARGF.read.strip.chars

# PART 1
#
# Packets are marked by four characters that are all different.
# How many characters need to be read to find the first start of packet marker?
stream.each.with_index(4) do |e, i|
  break puts i if stream[(i-4) .. i].tally.values.all?(1)
end

# PART 2
#
# Messages are marked by fourteen characters that are all different.
# How many characters need to be read to find the first start of message marker?
stream.each.with_index(14) do |e, i|
  break puts i if stream[(i-14) .. i].tally.values.all?(1)
end
