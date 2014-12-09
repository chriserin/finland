# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finland/version'

Gem::Specification.new do |spec|
  spec.name          = "finland"
  spec.version       = Finland::VERSION
  spec.authors       = ["Hashrocket Workstation"]
  spec.email         = ["dev@hashrocket.com"]
  spec.summary       = %q{ Test only the tests that are affected by your changes}
  spec.description   = %q{ Finland uses git diff and the coverage lib to determine if changes you've made affect the codepath of your tests.  If they do, run the test, if not, don't.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
