require_relative '../lib/bitstampede'
require 'pry'

class Example
  def initialize &block
    validate_env_vars
    client = Bitstampede::Client.new
    client.key = key
    client.secret = secret
    output block.call(client).inspect
  end

  private
  def validate_env_vars
    print_env_var_message if missing_either_var?
  end

  def missing_either_var?
    key.nil? || secret.nil?
  end

  def key
    ENV["BITSTAMP_KEY"]
  end

  def secret
    ENV["BITSTAMP_SECRET"]
  end

  def print_env_var_message
    output <<-MSG
      These examples assume that you have two env vars defined:

      BITSTAMP_KEY (which would be your user id)

      and

      BITSTAMP_SECRET (which would be your password)

      You don't appear to.  Rectify that, mnkay?
    MSG
    exit(1)
  end

  def output(message)
    STDOUT.puts message
  end
end
