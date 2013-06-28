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
      mapper.map_order(net.post("buy", { price: price.to_digits, amount: amount.to_digits }))
    end

    private
    def net
      @net ||= Net.new(self)
    end

    def mapper
      @mapper ||= Mapper.new
    end
  end
end
