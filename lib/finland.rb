require 'fileutils'
require "finland/version"
require 'finland/git_diff'
require 'finland/compare'
require "snapshot_coverage"

module Finland
  class << self
    attr_accessor :observed_dirs, :indexes, :index_location, :previous_snapshot
  end
  Coverage.start

  self.observed_dirs = [Dir.pwd]

  def self.index_test(test_name, &test_block)
    previous_snapshot = current_snapshot
    test_block.call
    snapshot = current_snapshot
    current_index[test_name] = diff_snapshot(snapshot, previous_snapshot)
    write_index(current_index)
  end

  def self.current_snapshot
    Coverage.snapshot.select {|file_name, value| observed_dirs.any? {|f| file_name.include? f} }
  end

  def self.diff_snapshot(snapshot, previous_snapshot)
    result = {}
    snapshot.each do |file_name, code_array|
      if previous_snapshot[file_name] != nil
        result[file_name] = diff_array(previous_snapshot[file_name], code_array) unless code_array == previous_snapshot[file_name]
      else
        result[file_name] = code_array
      end
    end
    result
  end

  def self.current_index
    self.indexes = indexes || load_index
  end

  def self.diff_array(old_arr, new_arr)
    new_arr.map{|x| x || 0}.zip(old_arr.map {|x| x || 0}).map {|x| x.inject(:-)};
  end

  def self.write_index(indexes)
    path = File.expand_path index_location
    dir = File.dirname path
    FileUtils.mkdir_p dir
    dumped_index = Marshal.dump(indexes)
    File.write(index_location, dumped_index, encoding: 'ASCII-8BIT')
  end

  def self.load_index
    if File.exists? index_location
      Marshal.load(File.read(index_location))
    else
      {}
    end
  end

  def self.affected_tests
    diff = Finland::GitDiff.parse(Finland::GitDiff.get(1))
    Finland::Compare.determine_affected_tests(load_index, diff)
  end
end
