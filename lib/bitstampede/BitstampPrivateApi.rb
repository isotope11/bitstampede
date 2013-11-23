module Bitstampede
  module BitstampPrivateApi

    # user balance
    #
    # @return {Entities::UserBalance} 
    #
    # @example
    #   client.user_balance
    #     # #<Bitstampede::Entities::UserBalance:78051540
    #     # usd_balance: 0.36
    #     # btc_balance: 0.36112094
    #     # usd_reserved: 0.0
    #     # btc_reserved: 0.0
    #     # usd_available: 0.36
    #     # btc_available: 0.36112094
    #     # fee: 0.5
    #   client.user_balance.usd_balance
    #     # 0.36
    def user_balance
      mapper.map_user_balance(net.make_request_and_expect_json(:POST,"balance"))
    end
    alias_method :balance, :user_balance

    # User transactions executed in the past
    #
    # @param opts [Hash] opts - see https://www.bitstamp.net/api/
    # @option opts [Fixnum] :offset  ex: 3
    # @option opts [Fixnum] :limit   ex: 200
    # @option opts [String] :sort    ex: "asc"
    #
    #
    # @return {Array<Entities::UserTransaction} 
    #
    # @example
    #   client.user_transactions
    #     #[
    #     #    [0] #<Bitstampede::Entities::UserTransaction:77164860
    #     #  datetime: 2013-11-21 00:23:34 +0100
    #     #  id: 2015119
    #     #  type: :markettrade
    #     #  usd: -89.36
    #     #  btc: 0.15013755
    #     #  fee: 0.36
    #     #  order_id: 9633016
    #     #>
    #     #,
    #     #    [1] #<Bitstampede::Entities::UserTransaction:77165740
    #     #  datetime: 2013-11-21 08:31:31 +0100
    #     #  id: 2019293
    #     #  type: :markettrade
    #     #  usd: 2.0
    #     #  btc: -0.0031541
    #     #  fee: 0.01
    #     #  order_id: 9646664
    #     #>
    #     #...
    #     #,
    #     #    [9] #<Bitstampede::Entities::UserTransaction:77207200
    #     #  datetime: 2013-11-23 12:21:51 +0100
    #     #  id: 2057477
    #     #  type: :markettrade
    #     #  usd: 306.4
    #     #  btc: -0.36112094
    #     #  fee: 1.17
    #     #  order_id: 9740110
    #     #]
    #     
    #     client.user_transactions[0].datetime          # 0 is the most recent, -1 is the oldest
    #
    def user_transactions(opts={})
      # opts can have any of these keys:
      # opts = { offset: 3,
      #           limit: 200,
      #            sort: "asc"
      #        }
      mapper.map_user_transactions(net.make_request_and_expect_json(:POST,"user_transactions",opts))
    end
    alias_method :transactions, :user_transactions

    # User orders (limit-buy or sell) currently open and ready to be executed
    #
    # @return [Array<Entities::UserOrder>]
    def user_orders
      mapper.map_user_orders(net.make_request_and_expect_json(:POST,"open_orders"))
    end
    alias_method :orders, :user_orders

    # Open new buy-limit order to buy *amount_btc* for *price_usd*
    #
    # @return {Entities::UserOrder}
    def buy!(amount_btc, price_usd)
      trade!("buy", amount_btc, price_usd)
    end

    # Open new sell-limit order to sell *amount_btc* for *price_usd*
    #
    # @return {Entities::UserOrder}
    def sell!(amount_btc, price_usd)
      trade!("sell", amount_btc, price_usd)
    end

    # Cancel an existing order (buy-limit or sell-limit), with *order_id*
    #
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
