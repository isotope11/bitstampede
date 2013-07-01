require_relative './bitstampede/version'
require_relative './bitstampede/client'
require 'multi_json'
require 'json'

module Bitstampede
  class StandardError < ::StandardError; end

  module Helpers
    def self.json_parse(string)
      MultiJson.load(string)
    end
  end
end
