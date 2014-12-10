module Finland
  class GitDiff
    def self.get(commits_number)
      `git diff -U0 HEAD`
    end

    def self.parse(diff_txt)
      reduced_lines = diff_txt.lines.reject {|x| x.match /^[-+] /}
      reduced_lines = reduced_lines.reject {|x| x.match /^index|\+\+\+/ }

      current_file = ""
      reduced_lines.each_with_object({}) do |line, result|
        if match = line.match(/^--- a\/(.*)$/)
          current_file = match[1]
          result[current_file] = []
        elsif match = line.match(/^@@/)
          result[current_file] << parse_line_diff(line)
        end
      end
    end

    def self.parse_line_diff(line)
      match = line.match /^@@ -(?<line_number>\d+),?(?<line_quantity>\d+)? \+\d/
      number = match["line_number"].to_i
      quantity = match["line_quantity"].to_i
      (number - 1)..((number + [quantity - 1, 0].max) - 1)
    end
  end
end
