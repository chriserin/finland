
Given(/^a program and a test suite$/) do
  #We can use the finland rspec test suite
end

When(/^I run the full test suite$/) do
  require 'rspec'
  output = capture(:stdout) do
    RSpec::Core::Runner.run ["spec"]
  end

  match = output.match /(\d+) examples?/
  @examples_count = match[1]
end

Then(/^I see the test index saved to a file$/) do
  expect(File.exists?('index.txt')).to equal(true)
end

When(/^I make a change to a code file$/) do
  `sed 's/$/\#no-op/g' lib/finland/compare.rb > lib/tempfile.rb ; mv lib/tempfile.rb lib/finland/compare.rb`
end

Then 'I see finlands affected tests' do
  affected_tests = Finland.affected_tests
  expect(affected_tests.count).to be < @examples_count.to_i
  expect(affected_tests.count).to be > 0
end

When(/^I run the test suite with Finland$/) do
  output = capture(:stdout) do
    RSpec::Core::Runner.run Finland.affected_tests.grep /_spec/
  end

  match = output.match /(\d+) examples?/
  @new_examples_count = match[1]
end

Then(/^I see only a subtest of tests were run$/) do
  expect(@new_examples_count.to_i < (@examples_count.to_i * 3)).to eq true
  expect(@new_examples_count.to_i > (@examples_count.to_i * 2)).to eq true
end

def capture(stream)
  stream = stream.to_s
  require 'tempfile'
  captured_stream = Tempfile.new(stream)
  stream_io = eval("$#{stream}")
  origin_stream = stream_io.dup
  stream_io.reopen(captured_stream)

  yield

  stream_io.rewind
  return captured_stream.read
ensure
  captured_stream.close
  captured_stream.unlink
  stream_io.reopen(origin_stream)
end
