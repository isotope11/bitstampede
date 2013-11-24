require 'net/http/persistent'
require_relative '../bitstampede/NonceGenerator'
require 'multi_json'
require 'json'

module Bitstampede
  class Net
    attr_reader :client

    def initialize(client)
      @client = client
    end

    # This method executes a request (as indicated in request_type, like :POST or :GET) and checks the response.
    # If the response is JSON, then it parses it and returns it as a ruby object
    # If the response is not JSON (but another thing like normal HTML), then it will raise Bitstampede::StandardError
    #
    # @param [Symbol] request_type :POST or :GET - see #raw_request
    # @param [Symbol] endpoint - see #raw_request 
    # @param [Hash] options - see {#raw_request}
    #
    # @raise [Bitstampede::StandardError] 
    # @return [Object] ruby object of JSON response parsed
    def make_request_and_expect_json(request_type, endpoint, options={})
      json_or_html = fix_jsonbug(raw_request(request_type,endpoint, options))
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

    # @param [Symbol] request_type either :POST or :GET
    # @param [String] endpoint last part of Api url (ex: "ticker" or "balance")
    # @param [Hash] options used only for these requests: POST
    def raw_request(request_type, endpoint, options)
      @http ||= ::Net::HTTP::Persistent.new 'bitstampede'
      uri = URI url_for(endpoint)
      case request_type
      when :POST
        post = ::Net::HTTP::Post.new uri.path
        post.set_form_data options.merge(auth_options)
        @nonce = nil      # avoid reusing the last nonce
        @http.request(uri, post).body
      when :GET
        # get = Net::HTTP::Get.new uri.request_uri
        # response = http.request get
        uri.query = URI.encode_www_form( options ) 
        @http.request(uri).body
        #binding.pry
      else
        raise Bitstampede::StandardError.new("Dont know request_type='#{request_type}'")
      end
    end

    def parse_json(string)
      parsed_json = MultiJson.load(string)
    end

    # For some crazy reason, bitstamp is returning ruby hash strings rather than
    # JSON objects right now ಠ_ಠ  I'm just going to gsub '=>' to ':' to 'solve'
    # it for now.  Not thrilled with this.
    def fix_jsonbug(whish_this_was_reliable_json)
      whish_this_was_reliable_json.gsub('=>', ':')
    end

  end
end

