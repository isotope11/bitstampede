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

    def post(endpoint, options={})
      HTTParty.post(url_for(endpoint), options.merge(auth_options)).to_s
    end

    private
    def url_for(endpoint)
      base_url + endpoint + '/'
    end

    def base_url
      'https://www.bitstamp.net/api/'
    end

    def auth_options
      {
        key: key,
        secret: secret
      }
    end
  end
end

