require 'time'
require 'bigdecimal'

module Bitstampede
  module Entities

    # This class is a template that should be used only to subclass new Entities, like:
    #
    #   require_relative './base'
    #   module Bitstampede; module Entities;
    #     class MyNewEntity < Base
    #       def self.mappings
    #          # Here you define a hash that should indicate the json-data-types and the Base.<mapping-method> that should be used to convert the json data into a ruby object
    #          # The Base.<mapping.method> should be one class-method already defined in Base (ex: map_time) or one class-method that you implement inside your MyNewEntity class (like Order.map_type)
    #       end
    #       setup_readers
    #     end
    #   end; end
    #
    class Base
      def initialize(hash)
        check_for_errors(hash)
        map_instance_variables(hash)
      end

      def inspect
        inspect_string = "#<#{self.class}:#{self.object_id} "
        self.class.mappings.each_pair do |key,val|
          inspect_string << "#{key}: #{val.inspect} "
        end
        inspect_string << " >"
        inspect_string
      end

      def self.mappings
        raise "I must be coded in the subclass"
      end

      def self.setup_readers
        self.mappings.keys.each {|k| attr_reader k.to_sym }
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
        self.class.mappings.each_pair do |key,map_method|
          instance_variable_set("@#{key}", map_method.call(hash[key.to_s].to_s))
        end
      end

      def check_for_errors(hash)
        if hash.has_key?("error")
          raise Bitstampede::StandardError.new(hash["error"]) if hash["error"].is_a?(String)
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
