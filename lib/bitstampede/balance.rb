module Bitstampede
  class Balance
    def self.keys
      %w(
        usd_balance
        btc_balance
        usd_reserved
        btc_reserved
        usd_available
        btc_available
        fee
      )
    end

    keys.each {|k| attr_accessor k.to_sym }

    def initialize(balance_hash)
      self.class.keys.each { |key| self.send("#{key}=", BigDecimal(balance_hash[key].to_s)) }
    end
  end
end
