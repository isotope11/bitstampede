require_relative 'standarderror'
require_relative 'net'
require_relative 'mapper'
require 'bigdecimal/util'

module Bitstampede
  class Client
    attr_accessor :key, :secret, :client_id

    def initialize(options = {})
      @key       = options[:key]
      @secret    = options[:secret]
      @client_id = options[:client_id]
    end

    def balance
      mapper.map_balance(net.post_assure_json("balance"))
    end

    #   # See https://www.bitstamp.net/api/
    #   opts = {
    #     offset: 3,
    #     limit:  200,
    #     sort:   "asc"
    #   }
    def transactions(opts={})
      mapper.map_transactions(net.post_assure_json("user_transactions",opts))
    end

    def orders
      mapper.map_orders(net.post_assure_json("open_orders"))
    end

    def buy!(amount, price)
      trade!("buy", amount, price)
    end

    def sell!(amount, price)
      trade!("sell", amount, price)
    end

    def cancel(id)
      wrapping_standard_error do
        mapper.map_cancel(net.post_assure_json("cancel_order", { id: id.to_s }))
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
        mapper.map_order(net.post_assure_json(type, { price: price.to_digits, amount: amount.to_digits }))
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
