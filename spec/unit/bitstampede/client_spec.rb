require_relative '../../spec_helper'

describe Bitstampede::Client do
  subject { described_class.new }
  let(:net){ subject.send(:net) }
  let(:mapper){ subject.send(:mapper) }

  before do
    subject.key = '1'
    subject.secret = '2'
  end

  describe '#balance' do
    let(:api_balance_response){ double }
    let(:balance_object){ double }

    before do
      net.stub(:post).and_return(api_balance_response)
      mapper.stub(:map_balance).and_return(balance_object)
    end

    it 'requests the balance from the API' do
      subject.balance
      expect(net).to have_received(:post).with('balance')
    end

    it 'maps the API response to a Balance object' do
      subject.balance
      expect(mapper).to have_received(:map_balance).with(api_balance_response)
    end

    it 'returns the mapped object' do
      expect(subject.balance).to eq(balance_object)
    end
  end
end
