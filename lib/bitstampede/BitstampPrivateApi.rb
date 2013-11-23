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

    def orders
      mapper.map_orders(net.make_request_and_expect_json(:POST,"open_orders"))
    end

    def buy!(amount, price)
      trade!("buy", amount, price)
    end

    def sell!(amount, price)
      trade!("sell", amount, price)
    end

    def cancel!(id)
      wrapping_standard_error do
        mapper.map_cancel(net.make_request_and_expect_json(:POST,"cancel_order", { id: id.to_s }))
      end
    end

    private

    def trade!(type, amount, price)
      wrapping_standard_error do
        mapper.map_order(net.make_request_and_expect_json(:POST,type, { price: price.to_digits, amount: amount.to_digits }))
      end
    end

  end
end
