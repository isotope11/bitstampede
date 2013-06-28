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
      map_response(raw_post(endpoint, options))
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
        user: key,
        password: secret
      }
    end

    # For some crazy reason, bitstamp is returning ruby hash strings rather than
    # JSON objects right now ಠ_ಠ  I'm just going to gsub '=>' to ':' to 'solve'
    # it for now.  Not thrilled with this.
    def map_response(wish_this_were_reliably_json)
      wish_this_were_reliably_json.gsub('=>', ':')
    end

    def raw_post(endpoint, options)
      HTTParty.post(url_for(endpoint), body: options.merge(auth_options)).to_s
    end
  end
end

