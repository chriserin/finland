#/usr/bin/ruby.rb

require 'finland'

diff = Finland::GitDiff.parse(Finland::GitDiff.get(1)))

puts Finland::Compare.determine_affected_tests(Finland.load_index, diff)
