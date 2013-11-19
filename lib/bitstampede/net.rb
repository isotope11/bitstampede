require 'net/http/persistent'
require_relative '../bitstampede/nonce_generator'
require 'multi_json'
require 'json'

module Bitstampede
  class Net
    attr_reader :client

    def initialize(client)
      @client = client
    end

    # This method executes a POST request and checks the response.
    # If the response is JSON, then it parses it and returns it as a ruby object
    # If the response is not JSON (but another thing like normal HTML), then it will raise Bitstampede::StandardError
    #
    def post_assure_json(*args)
      json_or_html = post(*args)
      # Assure we get JSON, or raise error
      begin
        parsed_json = parse_json(json_or_html)
      rescue
        `mktemp`.chomp.tap do |tmp_file|
          File.open(tmp_file,'w') {|f| f.write json_or_html}
          raise Bitstampede::StandardError.new("Instead of JSON, I got an HTML response body, which is probably happening because bistamp site may be overloaded. The HTML response body received is saved in '#{tmp_file}' so you can check it out. Aborting")
        end
      end
      parsed_json
    end

    def post(endpoint, options={})
      map_response(raw_post(endpoint, options))
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

    def key
      client.key
    end

    def secret
      client.secret
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
    def map_response(whish_this_was_reliable_json)
      whish_this_was_reliable_json.gsub('=>', ':')
    end

    def parse_json(string)
      parsed_json = MultiJson.load(string)
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

