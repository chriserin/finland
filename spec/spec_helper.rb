require 'snapshot_coverage'
Coverage.start
require 'finland'

Finland.index_location = "index.txt"
Finland.observed_dirs << Pathname(__FILE__).join('../../lib').to_s

RSpec.configure do |c|
  c.around(:each) do |example|
    Finland.index_test(example.location) do
      example.run
    end
  end
end
