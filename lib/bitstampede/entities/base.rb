require 'bigdecimal'

module Bitstampede
  module Entities
    class Base
      def self.setup_readers
        keys.each {|k| attr_reader k.to_sym }
      end

      def self.keys
        self.mappings.keys
      end

      def initialize(hash)
        check_for_errors(hash)
        map_instance_variables(hash)
      end

      def inspect
        inspect_string = "#<#{self.class}:#{self.object_id} "
        self.class.keys.each do |key|
          inspect_string << "#{key}: #{send(key).inspect} "
        end
        inspect_string << " >"
        inspect_string
      end

      def self.map_time
        ->(val) { Time.parse(val) }
      end

      def self.map_int
        ->(val) { val.to_i }
      end

      def self.map_decimal
        ->(val) { BigDecimal(val) }
      end

      private
      def map_instance_variables(hash)
        self.class.keys.each do |key|
          instance_variable_set("@#{key}", self.class.mappings[key].call(hash[key.to_s].to_s))
        end
      end

      def check_for_errors(hash)
        if hash.has_key?("error")
          if hash["error"].has_key?("__all__")
            raise Bitstampede::StandardError.new(hash["error"]["__all__"].join(".  "))
          else
            raise Bitstampede::StandardError.new("Bitstamp API Error #404")
          end
        end
      end
    end
  end
end
