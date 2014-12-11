require 'spec_helper'
require 'finland/compare'

describe Finland::Compare do
  context '#determine_affected_tests' do
    it 'should compare the index to the diff to determine which tests were affected' do
      index = {"subtract:1" => {"subtract.rb" => [1, 1, 0]}}
      diff = {"subtract.rb" => [1..1]}
      affected_tests = Finland::Compare.determine_affected_tests(index, diff)
      expect(affected_tests).to eq ["subtract:1"]
    end

    it 'should return an empty array if the diff references a different file than the test index' do
      index = {"subtract:1" => {"subtract.rb" => [1, 1, 0]}}
      diff = {"add.rb" => [1..1]}
      affected_tests = Finland::Compare.determine_affected_tests(index, diff)
      expect(affected_tests).to eq []
    end

    it 'should return an empty array if the diff references a different part of the same file' do
      index = {"subtract:1" => {"subtract.rb" => [1, 1, 0, 0]}}
      diff = {"subtract.rb" => [3..3]}
      affected_tests = Finland::Compare.determine_affected_tests(index, diff)
      expect(affected_tests).to eq []
    end
  end
end
