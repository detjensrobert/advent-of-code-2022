#!/usr/bin/env ruby

require 'fileutils'

day = ARGV[0].to_i

if day == 0
  puts "usage: #{$0} <day>"
  exit 1
end

padded = "day%02i" % day

Dir.mkdir(padded)
Dir.chdir(padded)

File.write("day#{day}.rb", DATA.read)
FileUtils.touch("test")
`aoc download --day #{day} --input-only`

__END__

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
end

# Input is
input = ARGF.read.split("\n")
