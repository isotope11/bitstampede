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
      Entities::Order.new(parsed(order))
    end

    def map_cancel(result)
      result == 'true'
    end

    private
    # Allow passing either a String or anything else in.  If it's not a string,
    # we assume we've already parsed it and just give it back to you.  This
    # allows us to handle things like collections more easily.
    def parsed(json)
      if(json.is_a?(String))
        Bitstampede::Helpers.json_parse(json)
      else
        json
      end
    end
  end
end
