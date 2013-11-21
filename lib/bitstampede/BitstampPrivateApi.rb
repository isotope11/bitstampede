module Bitstampede
  module BitstampPrivateApi
    def balance
      mapper.map_balance(net.make_request_and_expect_json(:POST,"balance"))
    end

    #   # See https://www.bitstamp.net/api/
    #   opts = {
    #     offset: 3,
    #     limit:  200,
    #     sort:   "asc"
    #   }
    def transactions(opts={})
      mapper.map_transactions(net.make_request_and_expect_json(:POST,"user_transactions",opts))
    end

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
