module Bitstampede
  class Client
    attr_accessor :key
    attr_accessor :secret

    def initialize
    end

    def balance
      mapper.map_balance(net.post("balance"))
    end

    private
    def net
      @net ||= Object.new # Do this
    end

    def mapper
      @mapper ||= Object.new # Do this
    end
  end
end
