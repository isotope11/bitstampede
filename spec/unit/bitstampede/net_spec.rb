require_relative '../../spec_helper'

describe Bitstampede::Net do
  let(:client){ double }
  subject(:net) { described_class.new(client) }

  before do
    client.stub(:secret).and_return(1)
    client.stub(:key).and_return(2)
  end

  it 'gets instantiated with a client' do
    expect(net.client).to eq(client)
  end

  it 'defers to its client for secret' do
    expect(net.secret).to eq(1)
  end

  it 'defers to its client for key' do
    expect(net.key).to eq(2)
  end

  describe '#post' do
    describe 'any_endpoint' do
      let(:example_balance) do
        <<-JSON
          {
            "foo": "bar"
          }
        JSON
      end

      before do
        FakeWeb.register_uri(:post, "https://www.bitstamp.net/api/balance/", body: example_balance)
      end

      it "queries the appropriate endpoint and returns its body as a string" do
        expect(json_parse(net.post('balance'))).to eq(json_parse(example_balance))
      end
    end
  end
end
