#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'yaml'

# Input is shell history + output with file sizes
entries = ARGF.read.split('$ ').map { |entry| entry.strip.split("\n") }.reject(&:empty?)

dirtree = {"/" => {}}
current_dir = []

# create file tree with sizes
entries.each do |cmd, *output|
  case cmd.split
  in ['cd', '/'] then current_dir = ["/"]
  in ['cd', '..'] then current_dir.pop
  in ['cd', path] then current_dir.push path

  in ['ls']
    output.each do |f|
      case f.split
      in 'dir', name
        dirtree.dig(*current_dir)[name] ||= {}
      in size, file
        dirtree.dig(*current_dir)[file] = size.to_i
      end
    end
  end
end

# remove nested root node from parsing
dirtree = dirtree["/"]

# puts dirtree.to_yaml

# PART 1
#
# Find all of the directories with a total size of at most 100_000.
# What is the sum of the total sizes of those directories?

# find all directory sizes
def sizes(dir)
  # recurse into subdirs (hash entries)
  subdirs = dir.values.filter { |e| e.is_a? Hash }.map { |d| sizes(d) }.flatten
  # own size is subdirs + sum of direct files
  own_size = (subdirs + dir.values.filter { |e| e.is_a? Integer }).sum

  subdirs + [own_size]
end

puts sizes(dirtree).sort.filter { |s| s < 100_000 }.sum

# PART 2
#
# Total disk space is 70_000_000. The update requires 30_000_000 free.
# What is the size of the smallest dir that would free up enough space?

# total - used + x > free
# 70M - /.size + x > 30M
free_space = 70_000_000 - sizes(dirtree).max
puts sizes(dirtree).filter {|s| free_space + s > 30_000_000 }.sort

# puts sizes(dirtree).sort
