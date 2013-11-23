require_relative './Base'

module Bitstampede
  module Entities
    class Order < Base
      class InvalidTypeError < Bitstampede::StandardError; end

      def self.map_type
        ->(val) do
          case val.to_s
          when '0'
            :buy
          when '1'
            :sell
          else
            raise InvalidTypeError
          end
        end
      end

      def self.mappings
        {
          id: map_int,
          datetime: map_time,
          type: map_type,
          price: map_decimal,
          amount: map_decimal
        }
      end

      setup_readers
    end
  end
end
