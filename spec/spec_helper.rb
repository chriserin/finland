require 'snapshot_coverage'
Coverage.start
require 'finland'

Finland.index_location = "index.txt"

RSpec.configure do |c|
  c.around(:each) do |example|
    Finland.index_test(example.location) do
      example.run
    end
  end
end
