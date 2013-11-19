require_relative './entities/balance'
require_relative './entities/order'
require_relative './entities/transaction'

module Bitstampede
  class Mapper
    def initialize
    end

    def map_balance(balance_json)
      Entities::Balance.new(balance_json)
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
