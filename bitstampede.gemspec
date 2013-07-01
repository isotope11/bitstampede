# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitstampede/version'

Gem::Specification.new do |spec|
  spec.name          = "bitstampede"
  spec.version       = Bitstampede::VERSION
  spec.authors       = ["Josh Adams"]
  spec.email         = ["josh@isotope11.com"]
  spec.description   = %q{This is a client library for the Bitstamp API that supports instantiating multiple clients in the same process.}
  spec.summary       = %q{Fantastic bitstamp library.}
  spec.homepage      = "http://github.com/isotope11/bitstampede"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'oj'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '2.14.0.rc1'
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "pry"
end
