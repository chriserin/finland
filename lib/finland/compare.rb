module Finland
  class Compare
    def self.determine_affected_tests(index, diff)
      index.select do |test_name, files|
        diff.any? do |file_name, ranges|
          files[file_name] and ranges.any? do |line_range|
            files[file_name][line_range].inject(:+) > 0
          end
        end
      end.keys
    end
  end
end
