require_relative './entities/UserBalance'
require_relative './entities/Order'
require_relative './entities/Transaction'
require_relative './entities/Ticker'

module Bitstampede
  class Mapper
    def initialize
    end

    def map_ticker(ticker_json)
      Entities::Ticker.new(ticker_json)
    end

    def map_general_order_book(gob_json)
      # gob_json = 
      # {"timestamp"=>    "1384916421",
      #  "bids"=>         [
      #                     ["555.57", "1.06213324"],
      #                     ["555.55", "22.56364904"],
      #                     ...
      #                   ],
      #  "asks"=>         [
      #                     ["563.75", "0.18591335"],
      #                     ["563.76", "1.77000000"],
      #                     ...
      #                   ]
      # }
      #

      # TODO: finish this...
      # basically:
      #   class Entities::GeneralOrderBook
      #       def self.mappings
      #         { timestamp:  map_time,
      #           bids:       map_orderbook_entries
      #           asks:       map_orderbook_entries
      #         }
      #       end
      #
      #       def map_orderbook_entries
      #         >-(val) do 
      #           # val = [
      #           #         ["555.57", "1.06213324"],
      #           #         ["555.55", "22.56364904"],
      #           #         ...
      #           #       ]
      #           val.map { ... }
      #         end
      #         
      #       end
      binding.pry
      ap gob_json
      gob_json.map{|o| map_order(o) }
    end

    def map_user_balance(user_balance_json)
      Entities::UserBalance.new(user_balance_json)
    end

    def map_transactions(transactions_json)
      transactions_json.map{|t| map_transaction(t) }
    end

    def map_transaction(transaction_json)
      Entities::Transaction.new(transaction_json)
    end

    def map_orders(orders_json)
      orders_json.map{|o| map_order(o) }
    end

    def map_order(order_json)
      Entities::Order.new(order_json)
    end

    def map_cancel(result)
      result == 'true'
    end

  end
end
