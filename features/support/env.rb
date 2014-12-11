require 'snapshot_coverage'
Coverage.start
require 'finland'

Finland.index_location = "index.txt"

Around do |scenario, block|
  Finland.index_test(scenario.location.to_s) do
    block.call
  end
end
