require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'
require 'rspec/autorun'
require 'bundler'
Bundler.setup

require_relative '../lib/bitstampede'
