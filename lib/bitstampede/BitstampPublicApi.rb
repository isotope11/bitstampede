module Bitstampede
  module BitstampPublicApi

    def ticker
      mapper.map_ticker(net.make_request_and_expect_json(:GET, "ticker")) 
    end

    # @return {Entities::HouseOrderBook} the order-book with all current open orders, from all Bitstamp users
    #
    # @example 
    #    hob = client.house_order_book
    #    hob.asks[0].usd        # 0 is the highest
    #    hob.asks[0].btc
    #    hob.bids[0].usd
    #    hob.bids[0].btc
    #    
    def house_order_book
      mapper.map_house_order_book(net.make_request_and_expect_json(:GET, "order_book")) 
    end

    # List of last transactions executed in exchange
    #
    # @param [Hash] opts - see https://www.bitstamp.net/api/
    # @option opts [String] :time "hour" for 1 hour (default), or "minute" for 1 minute
    #
    # @return [Array<Entities::ShallowTransaction>] 
    #
    # @example
    #   hts = client.house_transactions
    #   hts[0].date             # 0 is the most recent transaction
    #   hts[0].tid
    #   hts[0].price            # usd
    #   hts[0].amount           # btc
    #
    def house_transactions(opts={time: "hour"})
      mapper.map_house_transactions(net.make_request_and_expect_json(:GET, "transactions",opts)) 
    end

  end
end
