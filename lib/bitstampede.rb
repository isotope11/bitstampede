require_relative './bitstampede/version'
require_relative './bitstampede/client'
require 'multi_json'
require 'yajl'

module Bitstampede
  module JSON
    def self.json_parse(string)
      MultiJson.load(string)
    end
  end
end
