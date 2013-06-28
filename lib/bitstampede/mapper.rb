require_relative './balance'

module Bitstampede
  class Mapper
    def initialize
    end

    def map_balance(json)
      Balance.new(parsed(json))
    end

    private
    def parsed(json)
      Bitstampede::JSON.json_parse(json)
    end
  end
end
