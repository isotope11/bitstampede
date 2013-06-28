require_relative 'net'
require_relative 'mapper'

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

    private
    def net
      @net ||= Net.new(self)
    end

    def mapper
      @mapper ||= Mapper.new
    end
  end
end
