#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'victor'
  gem 'matrix'
  gem 'rmagick'
  gem 'debug'
end

require 'victor'
require 'matrix'
require 'rmagick'

# Input is a list of sensors and their detected beacons.
sensors = ARGF.read.split("\n").map do |l|
  # extract numbers from text
  sx, sy, bx, by = l.scan(/\d+/).map(&:to_i)
  { sensor: Vector[sx, sy], beacon: Vector[bx, by] }
end

# PART 1
#
# Sensors can only measure the beacons closest to them.
# In the row y=2000000, how many positions cannot contain a beacon?

# calculate bounding points for each manhattan square
sensors.map! do |s|
  # find manhattan distance
  s[:dist] = (s[:sensor] - s[:beacon]).map(&:abs).sum
  s
end

def make_svg(sensors)
  # find max dimensions
  dims_x, dims_y = sensors.map do |s|
    [
      s[:sensor] + Vector[s[:dist], s[:dist]],
      s[:sensor] - Vector[s[:dist], s[:dist]]
    ]
  end.flatten.map(&:to_a).transpose.map{ |dim| Vector[*dim.minmax] }

  # adjust all coordinates to be positive
  adj = Vector[(0 - dims_x[0]).clamp(0..), (0 - dims_y[0]).clamp(0..)]
  dims_x += Vector[adj[0], adj[0]]
  dims_y += Vector[adj[1], adj[1]]
  sensors.map! do |s|
    s[:sensor] += adj
    s[:beacon] += adj
    s
  end

  # lets make an svg!
  svg = Victor::SVG.new viewbox: "0 0 #{dims_x[1]} #{dims_y[1]}", style: { background: '#000' }
  # add a background
  svg.build do
    # grid
    (0..dims_x[1]).each do |x|
      line x1: x, y1: dims_y[0], x2: x, y2: dims_y[1], stroke: 'grey', stroke_width: "0.05px"
    end
    (0..dims_y[1]).each do |y|
      line x1: dims_x[0], y1: y, x2: dims_x[1], y2: y, stroke: 'grey', stroke_width: "0.05px"
    end
    # axes
    line x1: dims_x[0], y1: adj[1], x2: dims_x[1], y2: adj[1], stroke: 'grey', stroke_width: "0.2px"
    line x1: adj[0], y1: dims_y[0], x2: adj[0], y2: dims_y[1], stroke: 'grey', stroke_width: "0.2px"
    text "0", x: adj[0], y: adj[1]+1, font_size: "2px", fill: 'grey'

    (-10..20).step(10).each do |o|
      line x1: dims_x[0], y1: adj[1] + o, x2: dims_x[1], y2: adj[1] + o, stroke: 'grey', stroke_width: "0.1px"
      line x1: adj[0] + o, y1: dims_y[0], x2: adj[0] + o, y2: dims_y[1], stroke: 'grey', stroke_width: "0.1px"
    end

    line x1: dims_x[0], y1: 10 + adj[1], x2: dims_x[1], y2: 10 + adj[1], stroke: 'white', stroke_width: "0.2px"
  end

  # fill in all beacon exclusion zones
  sensors.each do |s|
    color = "#" + (0..2).map{"%0x" % (rand * 0x80 + 0x80)}.join

    points = [
      s[:sensor] + Vector[s[:dist], 0],
      s[:sensor] + Vector[0, s[:dist]],
      s[:sensor] - Vector[s[:dist], 0],
      s[:sensor] - Vector[0, s[:dist]],
    ].map { |p| p.to_a.join(',') }.join ' '

    svg.build do
      g do
        polygon points: points, fill: color, fill_opacity: 0.5
        line x1: s[:sensor][0], y1: s[:sensor][1], x2: s[:beacon][0], y2: s[:beacon][1], stroke: color, stroke_width: "0.2px"
        # circle cx: s[:sensor][0], cy: s[:sensor][1], r: 0.5, fill: color
        text "S", x: s[:sensor][0] - 0.5, y: s[:sensor][1] + 0.5, font_size: "2px", fill: color
        # text "b", x: s[:beacon][0] - 0.5, y: s[:beacon][1] + 0.5, font_size: "2px", fill: color
      end
    end
  end

  svg.save 'beacons'
end

# ok actual algorithm time
# LINE_NO = 10
LINE_NO = 2000000
line = {}
sensors.each do |s|
  # only care about sensor ranges on the line
  sx, sy = s[:sensor].to_a
  next unless (sy - s[:dist] .. sy + s[:dist]).include? LINE_NO

  # puts "sensor #{s[:sensor]} + #{s[:dist]}"

  # fill in spots on the line
  cover_dist = s[:dist] - (sy - LINE_NO).abs

  # puts "delta on line: #{cover_dist}"
  # puts "checking from #{sx - cover_dist},#{LINE_NO} to #{sx + cover_dist},#{LINE_NO}"
  (sx - cover_dist .. sx + cover_dist).each { |x| line[x] ||= s[:sensor] }
end

# line.sort.to_h.chunk { |k,v| v }.each { |v, points|
#   s, e = points.map(&:first).minmax
#   puts "#{(s..e)}: #{v}"
# }
puts line.values.compact.size - 1

# PART 2
#
# The beacon is somewhere for x, y \in 0..4_000_000
# Find its tuner frequency (x * 4_000_000 + y).


# make_svg(sensors)
