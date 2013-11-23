module Bitstampede
  module BitstampPublicApi

    def ticker
      mapper.map_ticker(net.make_request_and_expect_json(:GET, "ticker")) 
    end

    # @returns The order-book with all current open orders, from all Bitstamp users of the exchange
    #    hob = client.house_order_book
    #    hob.asks[0].usd        # 0 is the highest
    #    hob.asks[0].btc
    #    hob.bids[0].usd
    #    hob.bids[0].btc
    #    
    #
    def house_order_book
      mapper.map_house_order_book(net.make_request_and_expect_json(:GET, "order_book")) 
    end

    def 

  end
end
