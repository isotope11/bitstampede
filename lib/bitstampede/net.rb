require 'httparty'

module Bitstampede
  class Net
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def secret
      client.secret
    end

    def key
      client.key
    end

    def post(endpoint)
      HTTParty.post(url_for(endpoint), key: key, secret: secret).to_s
    end

    private
    def url_for(endpoint)
      base_url + endpoint + '/'
    end

    def base_url
      'https://www.bitstamp.net/api/'
    end
  end
end

