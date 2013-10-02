require_relative '../../spec_helper'

describe Bitstampede::Mapper do
  subject(:mapper) { described_class.new }
  let(:json_object){ '{"foo": "bar"}' }
  let(:json_array){ '[{"foo": "bar"}]' }

  describe '#map_balance' do
    let(:balance) { double }

    before do
      Entities::Balance.stub(:new).and_return(balance)
    end

    it "maps a balance API response into a Balance entity" do
      mapper.map_balance(json_object)
      expect(Entities::Balance).to have_received(:new).with(json_parse(json_object))
    end

    it "returns the mapped Balance entity" do
      expect(mapper.map_balance(json_object)).to eq(balance)
    end
  end

  describe '#map_orders' do
    let(:order) { double }

    before do
      Entities::Order.stub(:new).and_return(order)
    end

    it "maps an open_orders API response into an array of Order entities" do
      mapper.map_orders(json_array)
      expect(Entities::Order).to have_received(:new).with(json_parse(json_array)[0])
    end
  end

  describe '#map_cancel' do
    it "maps a cancel API response to a boolean" do
      expect(mapper.map_cancel('true')).to eq(true)
      expect(mapper.map_cancel('false')).to eq(false)
    end
  end
end
