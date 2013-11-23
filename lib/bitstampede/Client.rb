require_relative 'StandardError'
require_relative 'Net'
require_relative 'Mapper'
require 'bigdecimal/util'
require_relative './BitstampPublicApi'
require_relative './BitstampPrivateApi'

module Bitstampede
  class Client
    include ::Bitstampede::BitstampPublicApi
    include ::Bitstampede::BitstampPrivateApi
    attr_accessor :key, :secret, :client_id

    def initialize(options = {})
      @key       = options[:key]
      @secret    = options[:secret]
      @client_id = options[:client_id]
    end
     
    private
    def net
      @net ||= Net.new(self)
    end

    def mapper
      @mapper ||= Mapper.new
    end

    def wrapping_standard_error &block
      begin
        yield
      rescue ::StandardError => e
        raise Bitstampede::StandardError.new(e.message)
      end
    end

  end
end

