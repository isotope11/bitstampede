require_relative './base'

module Bitstampede
  module Entities
    class Ticker < Base
      def self.mappings
        {
          last:     map_decimal,
          high:     map_decimal,
          low:      map_decimal,
          volume:   map_decimal,
          bid:      map_decimal,
          ask:      map_decimal
        }
      end

      setup_readers
    end
  end
end

