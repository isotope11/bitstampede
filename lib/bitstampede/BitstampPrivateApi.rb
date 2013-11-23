module Bitstampede
  module BitstampPrivateApi
    def user_balance
      mapper.map_user_balance(net.make_request_and_expect_json(:POST,"balance"))
    end
    alias_method :balance, :user_balance

    #   # See https://www.bitstamp.net/api/
    #   opts = {
    #     offset: 3,
    #     limit:  200,
    #     sort:   "asc"
    #   }
    def user_transactions(opts={})
      mapper.map_user_transactions(net.make_request_and_expect_json(:POST,"user_transactions",opts))
    end
    alias_method :transactions, :user_transactions

    # @return [Array<Entities::UserOrder>]
    def user_orders
      mapper.map_user_orders(net.make_request_and_expect_json(:POST,"open_orders"))
    end
    alias_method :orders, :user_orders

    # Open new buy-limit order to buy *amount_btc* for *price_usd*
    # @return {Entities::UserOrder}
    def buy!(amount_btc, price_usd)
      trade!("buy", amount_btc, price_usd)
    end

    # Open new sell-limit order to sell *amount_btc* for *price_usd*
    # @return {Entities::UserOrder}
    def sell!(amount_btc, price_usd)
      trade!("sell", amount_btc, price_usd)
    end

    # Cancel an existing order (buy-limit or sell-limit), with *order_id*
    # @return [TrueClass, FalseClass] true or false
    def cancel!(order_id)
      wrapping_standard_error do
        mapper.map_cancel(net.make_request_and_expect_json(:POST,"cancel_order", { order_id: order_id.to_s }))
      end
    end

    private

    def trade!(type, amount_btc, price_usd)
      wrapping_standard_error do
        mapper.map_user_order(net.make_request_and_expect_json(:POST,type, { price_usd: price_usd.to_digits, amount_btc: amount_btc.to_digits }))
      end
    end

  end
end
