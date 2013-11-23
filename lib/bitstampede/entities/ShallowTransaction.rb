require_relative './Base'

module Bitstampede
  module Entities
    class ShallowTransaction < Base
      def self.mappings
        { date:     map_unix_time,
          tid:      map_int,
          price:    map_decimal,
          amount:   map_decimal
        }
      end

      setup_readers
    end
  end
end



