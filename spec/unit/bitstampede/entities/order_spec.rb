require_relative '../../../spec_helper'

describe Bitstampede::Entities::Order do
  let(:order_hash){
    {
      "id" => "1",
      "datetime" => 1234567,
      "type" => 0,
      "price" => "1.23",
      "amount" => "10"
    }
  }
  subject{ described_class.new(order_hash) }

  it "has an id" do
    expect(subject.id).to eq(1)
  end
end
