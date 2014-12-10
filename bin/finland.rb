#!/usr/bin/env ruby
require 'pathname'

$LOAD_PATH << 'lib'

$:.unshift Pathname(__FILE__).join('../lib').to_s
require 'finland'

Finland.index_location = "index.txt"

diff = Finland::GitDiff.parse(Finland::GitDiff.get(1))
index = Finland.load_index
puts Finland::Compare.determine_affected_tests(index, diff)
