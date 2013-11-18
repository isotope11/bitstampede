require_relative './base'

module Bitstampede
  module Entities
    class Transaction < Base
      class InvalidTypeError < StandardError; end

      def self.map_type
        ->(val) do
          case val.to_s
          when '0' then :deposit
          when '1' then :withdrawal
          when '2' then :markettrade
          else
            raise InvalidTypeError
          end
        end
      end

      def self.mappings
        {
          datetime: map_time,
          id: map_int,
          type: map_type,
          usd: map_decimal,
          btc: map_decimal,
          fee: map_decimal,
          order_id: map_int
        }
      end

      setup_readers
    end
  end
end
