module Bitstampede
  module Entities
    class Base
      def self.setup_readers
        keys.each {|k| attr_reader k.to_sym }
      end

      def self.keys
        self.mappings.keys
      end

      def initialize(balance_hash)
        self.class.keys.each do |key|
          instance_variable_set("@#{key}", self.class.mappings[key].call(balance_hash[key.to_s].to_s))
        end
      end

      def inspect
        inspect_string = "#<#{self.class}:#{self.object_id} "
        self.class.keys.each do |key|
          inspect_string << "#{key}: #{send(key).inspect} "
        end
        inspect_string << " >"
        inspect_string
      end

      def self.map_int
        ->(val) { val.to_i }
      end

      def self.map_decimal
        ->(val) { BigDecimal(val) }
      end
    end
  end
end
