require 'net/http/persistent'
require_relative '../bitstampede/nonce_generator'

module Bitstampede
  class Net
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def post(endpoint, options={})
      map_response(raw_post(endpoint, options))
    end

    def key
      client.key
    end

    def secret
      client.secret
    end

    private
    def url_for(endpoint)
      base_url + endpoint + '/'
    end

    def nonce
      @nonce ||= NonceGenerator.new.generate
    end

    def base_url
      'https://www.bitstamp.net/api/'
    end

    def client_id
      client.client_id
    end

    def auth_options
      {
        key: key,
        nonce: nonce,
        signature: signature
      }
    end

    def signature
      params = "#{nonce}#{client_id}#{key}"
      hmac = OpenSSL::HMAC.new(secret, OpenSSL::Digest::SHA256.new)
      hmac.update(params).hexdigest.upcase
    end

    # For some crazy reason, bitstamp is returning ruby hash strings rather than
    # JSON objects right now ಠ_ಠ  I'm just going to gsub '=>' to ':' to 'solve'
    # it for now.  Not thrilled with this.
    def map_response(wish_this_were_reliably_json)
      wish_this_were_reliably_json.gsub('=>', ':')
    end

    def raw_post(endpoint, options)
      uri = URI url_for(endpoint)
      http = ::Net::HTTP::Persistent.new 'bitstampede'
      post = ::Net::HTTP::Post.new uri.path
      post.set_form_data options.merge(auth_options)
      @nonce = nil      # avoid reusing the last nonce
      http.request(uri, post).body
    end
  end
end

