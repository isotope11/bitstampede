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

    def buy!(amount, price)
      trade!("buy", amount, price)
    end

    def sell!(amount, price)
      trade!("sell", amount, price)
    end

    def cancel(id)
      wrapping_standard_error do
        mapper.map_cancel(net.post("cancel_order", { id: id.to_s }))
      end
    end

    private
    def net
      @net ||= Net.new(self)
    end

    def mapper
      @mapper ||= Mapper.new
    end

    def trade!(type, amount, price)
      wrapping_standard_error do
        mapper.map_order(net.post(type, { price: price.to_digits, amount: amount.to_digits }))
      end
    end

    def wrapping_standard_error &block
      begin
        yield
      rescue ::StandardError => e
        raise Bitstampede::StandardError.new(e.message)
      end
    end
  end
end
