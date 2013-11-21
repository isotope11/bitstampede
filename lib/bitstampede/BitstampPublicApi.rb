module Bitstampede
  module BitstampPublicApi

    def ticker
      mapper.map_ticker(net.make_request_and_expect_json(:GET, "ticker")) 
    end

    # @returns The order-book with all current open orders, from all Bitstamp users
    def general_order_book
      mapper.map_general_order_book(net.make_request_and_expect_json(:GET, "order_book")) 
    end

  end
end
