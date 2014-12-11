#!/usr/bin/env ruby
require 'pathname'

$LOAD_PATH << 'lib'

$:.unshift Pathname(__FILE__).join('../lib').to_s
require 'finland'

Finland.index_location = "index.txt"

puts Finland.affected_tests()
