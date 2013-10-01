require_relative '../../spec_helper'

describe Bitstampede::Net do
  let(:client){ double }
  subject(:net) { described_class.new(client) }

  before do
    client.stub(:secret).and_return('secret')
    client.stub(:key).and_return('key')
    client.stub(:client_id).and_return('1234')
  end

  it 'gets instantiated with a client' do
    expect(net.client).to eq(client)
  end

  it 'defers to its client for secret' do
    expect(net.secret).to eq('secret')
  end

  it 'defers to its client for key' do
    expect(net.key).to eq('key')
  end

  describe '#post' do
    let(:hmac) { double("hmac", :hexdigest => "hexdigest") }

    describe 'any_endpoint' do
      let(:example_balance) do
        <<-JSON
          {
            "foo": "bar"
          }
        JSON
      end

      before do
        OpenSSL::HMAC.stub(:new).with('secret', OpenSSL::Digest::SHA256.new){ hmac }
        Bitstampede::NonceGenerator.stub(:new) { double(:generate => "magical nonce") }
        FakeWeb.register_uri(:post, "https://www.bitstamp.net/api/balance/", body: example_balance)
        hmac.stub(:update) { hmac }
      end

      it "queries the appropriate endpoint and returns its body as a string" do
        expect(json_parse(net.post('balance'))).to eq(json_parse(example_balance))
      end

      it "generates a signature" do
        json_parse(net.post('balance'))
        expect(hmac).to have_received(:update).with("magical nonce1234key")
      end
    end
  end
end
