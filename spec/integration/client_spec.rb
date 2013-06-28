require_relative '../spec_helper'

describe "Integrating a client" do
  subject{ Client.new }

  before do
    subject.secret = '1'
    subject.key = '2'
  end

  it "handles #balance" do
    example_balance = <<-JSON
      {
        "usd_balance": "12.34",
        "btc_balance": "23.45",
        "usd_reserved": "1.11",
        "btc_reserved": "2.22",
        "usd_available": "11.23",
        "btc_available": "21.23",
        "fee": "0.5"
      }
    JSON

    FakeWeb.register_uri(:post, "https://www.bitstamp.net/api/balance/", body: example_balance)

    bal = subject.balance
    expect(bal.usd_balance).to eq(BigDecimal('12.34'))
  end

  it "handles #orders" do
    example_orders = <<-JSON
      [
        {
          "id": "1",
          "datetime": "1234567",
          "type": 0,
          "price": "12.34",
          "amount": "100"
        }
      ]
    JSON

    FakeWeb.register_uri(:post, "https://www.bitstamp.net/api/open_orders/", body: example_orders)

    orders = subject.orders
    expect(orders[0].type).to eq(:buy)
  end

  it "handles #buy!" do
    example_buy_response = <<-JSON
      {
        "id": "1",
        "datetime": "1234567",
        "type": 0,
        "price": "12.34",
        "amount": "100"
      }
    JSON

    FakeWeb.register_uri(:post, "https://www.bitstamp.net/api/buy/", body: example_buy_response)

    buy = subject.buy!(BigDecimal('1'), BigDecimal('100'))
    expect(buy.type).to eq(:buy)
  end
end
