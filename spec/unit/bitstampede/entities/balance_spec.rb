require_relative '../../../spec_helper'

describe Bitstampede::Entities::Balance do
  let(:balance_hash){
    {
      "usd_balance" => "111.12",
      "btc_balance" => "211.23",
      "usd_reserved" => "1.20",
      "btc_reserved" => "2.30",
      "usd_available" => "5.50",
      "btc_available" => "6.60",
      "fee" => "1.11"
    }
  }
  subject{ described_class.new(balance_hash) }

  it "has a usd_balance" do
    expect(subject.usd_balance).to eq(BigDecimal('111.12'))
  end

  it "has a btc_balance" do
    expect(subject.btc_balance).to eq(BigDecimal('211.23'))
  end

  it "has a usd_reserved" do
    expect(subject.usd_reserved).to eq(BigDecimal('1.20'))
  end

  it "has a btc_reserved" do
    expect(subject.btc_reserved).to eq(BigDecimal('2.30'))
  end

  it "has a usd_available" do
    expect(subject.usd_available).to eq(BigDecimal('5.50'))
  end

  it "has a btc_available" do
    expect(subject.btc_available).to eq(BigDecimal('6.60'))
  end

  it "has a fee" do
    expect(subject.fee).to eq(BigDecimal('1.11'))
  end

  it "can be inspected" do
    expect { subject.inspect }.to_not raise_error
  end
end
