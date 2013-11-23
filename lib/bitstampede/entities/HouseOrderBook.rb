require_relative './Base'

module Bitstampede
  module Entities
    class HouseOrderBook < Base
      def self.map_book_entries
        #NOTE: I know this is not perfect... but its enough and I cant spare the time...
        ->(val) do
          # val = '[
          #         ["555.57", "1.06213324"],
          #         ["555.55", "22.56364904"],
          #         ...
          #       ']
          # That is, the val is an array stored as String... (not from json, but from Base#map_instance_variables)
          # To unstringify it back to an Array, I'll use the ugly eval()
          val=eval(val)
          # val = [
          #        ["555.57", "1.06213324"],
          #        ["555.55", "22.56364904"],
          #        ...
          #       ]
          val.map do |usd_val,btc_val| 
            hash = { "usd" => usd_val,
                     "btc" => btc_val}
            Bitstampede::Entities::ShallowOrder.new(hash)
          end
        end
      end

      def self.mappings
        { timestamp:  map_unix_time,
          bids:       map_book_entries,
          asks:       map_book_entries
        }
      end

      setup_readers
    end
  end
end

