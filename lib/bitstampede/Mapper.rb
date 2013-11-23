require_relative './entities/UserBalance'
require_relative './entities/UserOrder'
require_relative './entities/UserTransaction'
require_relative './entities/Ticker'
require_relative './entities/HouseOrderBook'
require_relative './entities/ShallowOrder'
require_relative './entities/ShallowTransaction'

module Bitstampede
  class Mapper
    def initialize
    end

    def map_ticker(ticker_json)
      Entities::Ticker.new(ticker_json)
    end

    def map_house_order_book(hob_json)
      # hob_json = 
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
      Entities::HouseOrderBook.new(hob_json)
    end

    def map_house_transactions(hts_json)
      # hts_json = 
      # [{"date"=>"1385175941",
      #  "tid"=>2052522,
      #  "price"=>"810.80",
      #  "amount"=>"1.63100000"},
      #  ...
      # {"date"=>"1385172381",
      #  "tid"=>2051853,
      #  "price"=>"803.09",
      #  "amount"=>"1.00110822"}]
      hts_json.map {|ht| map_house_transaction(ht)}
    end

    def map_house_transaction(ht_json)
      # ht_json = 
      #  {"date"=>"1385175941",
      #  "tid"=>2052522,
      #  "price"=>"810.80",
      #  "amount"=>"1.63100000"}
      Entities::ShallowTransaction.new(ht_json)
    end


    def map_user_balance(user_balance_json)
      Entities::UserBalance.new(user_balance_json)
    end

    def map_user_transactions(user_transactions_json)
      user_transactions_json.map{|t| map_user_transaction(t) }
    end

    def map_user_transaction(user_transaction_json)
      Entities::UserTransaction.new(user_transaction_json)
    end

    def map_user_orders(user_orders_json)
      user_orders_json.map{|o| map_user_order(o) }
    end

    def map_user_order(user_order_json)
      Entities::UserOrder.new(user_order_json)
    end

    def map_cancel(result)
      result == 'true'
    end

  end
end
