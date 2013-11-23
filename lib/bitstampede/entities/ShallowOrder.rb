require_relative './Base'

module Bitstampede
  module Entities
    class ShallowOrder < Base
      def self.mappings
        { usd:  map_decimal,
          btc:  map_decimal
        }
      end

      setup_readers
    end
  end
end


