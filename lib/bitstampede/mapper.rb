require_relative './entities/balance'
require_relative './entities/order'

module Bitstampede
  class Mapper
    def initialize
    end

    def map_balance(json)
      Entities::Balance.new(parsed(json))
    end

    def map_orders(json)
      parsed(json).map{|o| map_order(o) }
    end

    def map_order(order)
      Entities::Order.new(order)
    end

    private
    def parsed(json)
      Bitstampede::Helpers.json_parse(json)
    end
  end
end
