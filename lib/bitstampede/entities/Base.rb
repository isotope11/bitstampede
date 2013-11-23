require 'time'
require 'bigdecimal'
require "awesome_print"

module Bitstampede
  module Entities

    # 
    # This class is a template that should be used only to subclass new Entities, like:
    #
    #   require_relative './Base'
    #   module Bitstampede; module Entities;
    #     class MyNewEntity < Base
    #       def self.mappings
    #          # Here you define a hash that should indicate the json-data-types and the MyNewEntity.<mapping-method> that should be used to convert the json data into a ruby object
    #          # The MyNewEntity.<mapping.method> should be one class-method already inherited from Base (ex: Base.map_time) or one class-method that you implement specifically inside your MyNewEntity class (ex: MyNewEntity.map_crazytype ; see also order.rb about Order.map_type)
    #       end
    #       setup_readers
    #     end
    #   end; end
    #
    #
    # The class methods
    #   MyNewEntity.map_xxx
    # are used to convert a json value (stored as a String) into the corresponding ruby value 
    # Each of these methods should return a lamba:
    #     ->(json_value_as_a_string) do
    #       # ...
    #       # convert json_value_as_a_string into the corresponding ruby value
    #       # ...
    #     end
    # There are already some methods defined and inherited from class Base, but in case you need to define (or override) an additional map_yyyy method for a specific json-data-type, it can do so by defining `MyNewEntity.map_yyyy`
    #
    class Base
      def self.mappings
        raise "I must be coded in the subclass"
      end

      def self.setup_readers
        self.mappings.keys.each {|k| attr_reader k.to_sym }
      end


      def self.map_time
        ->(val) { Time.parse(val) }
      end

      def self.map_unix_time
        ->(val) { Time.at(val.to_i) }
      end

      def self.map_int
        ->(val) { val.to_i }
      end

      def self.map_decimal
        ->(val) { BigDecimal(val) }
      end



      def initialize(hash)
        check_for_errors(hash)
        map_instance_variables(hash)
      end

      def inspect
        inspect_string = "#<#{self.class}:#{self.object_id}\n"
        self.class.mappings.each_pair do |key,map_method|
          inspect_string << ("  #{key}: " + eval("@#{key}.ai") + "\n")
        end
        inspect_string << ">\n"
        inspect_string
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
