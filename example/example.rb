require_relative '../lib/Bitstampede'
require 'pry'

class Example
  def initialize &block
    validate_env_vars
    client = Bitstampede::Client.new
    client.key = key
    client.secret = secret
    client.client_id = clientid
    output block.call(client)
  end

  private
  def validate_env_vars
    print_env_var_message if missing_env_var?
  end

  def missing_env_var?
    key.nil? || secret.nil? || clientid.nil?
  end

  def key
    ENV["BITSTAMP_KEY"]
  end

  def secret
    ENV["BITSTAMP_SECRET"]
  end

  def clientid
    ENV["BITSTAMP_CLIENTID"]
  end

  def print_env_var_message
    output <<-MSG
      These examples assume that you have three env vars defined:

      BITSTAMP_KEY
      BITSTAMP_SECRET
      BITSTAMP_CLIENTID

      You don't appear to.  Rectify that, mnkay?
    MSG
    exit(1)
  end

  def output(message)
    if(message.is_a?(String))
      STDOUT.puts message
    else
      STDOUT.puts message.inspect
    end
  end
end
