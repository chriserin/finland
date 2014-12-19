# Finland

Find the tests affected by a change.

## Why

We run the entire test suite after a change to ensure that all tests are passing before pushing to a central repo or deploying.  We only run the entire suite because we don't know which tests are affected by the code changes that have been made.  Running `finland` identifies the affected tests, which are the only tests requiring execution to ensure all test are passing.

## How it works

For each executed test Finland uses a combination of the coverage library included with ruby and the `set_trace_func` method to know which lines of code were executed for that test.  It persists that information to a file.  When a user runs finland it compares the output of 'git diff' against the lines executed for each test.  If an executed line is mentioned in the git diff, then the test is sent to the output.

## Requirements

Finland relies upon git diff to understand what code has changed in your application.

## Installation

Add this line to your application's Gemfile (gem only available via github currently):

```ruby
gem 'finland', github: 'chriserin/finland'
```

And then execute:

    $ bundle

## Setup

For rspec specs, include this code in the `spec_helper.rb` or equivalent file.

```ruby
RSpec.configure do |c|
  c.around(:each) do |example|
    Finland.index_test(example.location) do
      example.run
    end
  end
end
```

For cucumber specs, include this code in a support file in the features/support dir.

```ruby
Around do |scenario, block|
  Finland.index_test(scenario.location.to_s) do
    block.call
  end
end
```

## Usage

1. After installation and setup, run the entire test suite to index each test.  This will produce a file with the default name `finland_index.dat`.

2. After creating the finland index, make a change to a ruby file.  This change should be reflected in `git diff`.

3. Running the command `finland` will output all tests affected by the change.

4. To use with rspec run `rspec $(finland | grep spec)`.  Similarly use `cucumber $(finland | grep feature)` to use this tool with cucumbe.

Run finland
    
    $ finland

## Contributing

1. Fork it ( https://github.com/chriserin/finland/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
