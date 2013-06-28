require_relative 'net'
require_relative 'mapper'
require 'bigdecimal/util'

module Bitstampede
  class Client
    attr_accessor :key
    attr_accessor :secret

    def initialize
    end

    def balance
      mapper.map_balance(net.post("balance"))
    end

    def orders
      mapper.map_orders(net.post("open_orders"))
    end

    def buy!(price, amount)
      trade!("buy", price, amount)
    end

    def sell!(price, amount)
      trade!("sell", price, amount)
    end

    def cancel(id)
      mapper.map_cancel(net.post("cancel_order", { id: id.to_s }))
    end

    private
    def net
      @net ||= Net.new(self)
    end

    def mapper
      @mapper ||= Mapper.new
    end

    def trade!(type, price, amount)
      mapper.map_order(net.post(type, { price: price.to_digits, amount: amount.to_digits }))
    end
  end
end
