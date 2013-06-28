require_relative '../spec_helper'

describe Bitstampede do
  it "ought to be an instance rather than a retarded singleton like every freaking btc-related gem in existence apparently" do
    client = Bitstampede::Client.new
    expect(client.key).to eq(nil)
    expect(client.secret).to eq(nil)
    client.key = '1'
    client.secret = '2'
    expect(client.key).to eq('1')
    expect(client.secret).to eq('2')
  end
end
