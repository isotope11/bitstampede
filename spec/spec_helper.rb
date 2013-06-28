require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'rspec/autorun'
require 'bundler'
Bundler.setup

require 'fakeweb'
FakeWeb.allow_net_connect = false

require 'multi_json'
def json_parse(string)
  MultiJson.load(string)
end

require 'pry'

require_relative '../lib/bitstampede'
include Bitstampede
