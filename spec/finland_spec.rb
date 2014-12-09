require 'ostruct'
require 'finland'
require 'fileutils'

describe 'Finland' do
  it 'should exist' do
    expect(Finland).to_not eq nil
  end

  context 'indexing tests' do
    before do
      Finland.index_location = "tmp/finland_index.txt"
    end

    it '#index_test' do
      test_block = ->{ "execute test" }
      test = OpenStruct.new(name: "test_name", line: 10)
      Finland.index_test(test, test_block)
      expect(Finland.indexes["test_name:10"].class).to eq Hash
      expect(Finland.indexes["test_name:10"].keys.length).to eq 0
      expect(File.exists?("tmp/finland_index.txt")).to eq true
    end

    it '#index_test should index only the parts of that test' do
      Finland.observed_dirs << "spec/fixtures"
      require 'fixtures/add.rb'
      add_test_block = ->{ add(1, 2) }
      add_test = OpenStruct.new(name: "add_test", line: 1)
      Finland.index_test(add_test, add_test_block)

      require 'fixtures/subtract.rb'
      subtract_test_block = ->{ subtract(1, 2) }
      subtract_test = OpenStruct.new(name: "subtract_test", line: 1)
      Finland.index_test(subtract_test, subtract_test_block)

      indexes = Marshal.load(File.read("tmp/finland_index.txt"))
      expect(indexes['add_test:1'].class).to eq Hash
      expect(indexes['subtract_test:1'].class).to eq Hash
      expect(indexes['add_test:1'].keys.first).to include "spec/fixtures/add.rb"
      expect(indexes['subtract_test:1'].keys.first).to include "spec/fixtures/subtract.rb"
    end

    after do
      FileUtils.rm_rf "tmp"
    end
  end

  context 'diff snapshot' do
    it 'includes files from second snapshot not in first snapshot' do
      snapshot_a = {"file_a" => [1, 1, 0]}
      snapshot_b = {"file_a" => [1, 1, 0], "file_b" => [1, 1, 0]}
      result = Finland.diff_snapshot(snapshot_b, snapshot_a)
      expect(result).to eq({ "file_b" => [1, 1, 0] })
    end
  end

  context 'diff array' do
    it 'returns the second array minus the first array' do
      old_array = [1, nil, 1]
      new_array = [2, 1, 2]
      result = Finland.diff_array old_array, new_array
      expect(result).to eq [1, 1, 1]
    end
  end
end
