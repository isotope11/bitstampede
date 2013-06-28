require_relative '../../spec_helper'

describe Bitstampede::Mapper do
  subject { described_class.new }
  let(:json){ '{"foo": "bar"}' }

  describe '#map_balance' do
    let(:balance) { double }

    before do
      Balance.stub(:new).and_return(balance)
    end

    it "maps a balance API response into a Balance object" do
      subject.map_balance(json)
      expect(Balance).to have_received(:new).with(json_parse(json))
    end
  end
end
