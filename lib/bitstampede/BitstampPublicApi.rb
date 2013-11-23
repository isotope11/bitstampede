module Bitstampede
  module BitstampPublicApi

    def ticker
      mapper.map_ticker(net.make_request_and_expect_json(:GET, "ticker")) 
    end

    # @returns The order-book with all current open orders, from all Bitstamp users of the exchange
    def house_order_book
      mapper.map_house_order_book(net.make_request_and_expect_json(:GET, "order_book")) 
    end

  end
end
