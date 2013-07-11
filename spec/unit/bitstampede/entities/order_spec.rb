require_relative '../../../spec_helper'

describe Bitstampede::Entities::Order do
  subject{ described_class.new(order_hash) }

  context "a successful order" do
    let(:order_hash){
      {
        "id" => "1",
        "datetime" => 1234567,
        "type" => 0,
        "price" => "1.23",
        "amount" => "10"
      }
    }

    it "has an id" do
      expect(subject.id).to eq(1)
    end

    describe "type" do
      it "maps 0 to :buy" do
        expect(subject.type).to eq(:buy)
      end

      it "maps 1 to :sell" do
        order = described_class.new(order_hash.merge({"type" => 1}))
        expect(order.type).to eq(:sell)
      end

      it "raises InvalidTypeError for other values" do
        expect { described_class.new(order_hash.merge({"type" => 2})) }.to raise_error(Bitstampede::Entities::Order::InvalidTypeError)
      end
    end
  end

  context "an unsuccessful order" do
    context "with an __all__ key" do
      let(:order_hash){
        # Don't get mad at me, not my fault bitstamp errors look like this
        {
          "error" => {
            "__all__" => ["Minimum order size is $1"]
          }
        }
      }

      it "raises an appropriate error" do
        expect{ subject }.to raise_error(Bitstampede::StandardError, "Minimum order size is $1")
      end
    end

    context "without an __all__ key" do
      let(:order_hash){
        # Don't get mad at me, not my fault bitstamp errors look like this
        {
          "error" => {
            "neg" => ["Minimum order size is $1"]
          }
        }
      }

      it "raises an appropriate error" do
        expect{ subject }.to raise_error(Bitstampede::StandardError, "Bitstamp API Error #404")
      end
    end
  end
end
