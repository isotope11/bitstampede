require_relative '../../spec_helper'

describe Bitstampede::Client do
  subject(:client) { described_class.new }
  let(:net){ client.send(:net) }
  let(:mapper){ client.send(:mapper) }

  before do
    client.key = '1'
    client.secret = '2'
  end

  describe '#initialize' do
    it 'does not require any initial parameters' do
      expect { described_class.new }.not_to raise_error
    end

    it 'allows specifying key/secret on initialize' do
      client = described_class.new('KEY', 'SECRET')

      expect(client.key).to eql('KEY')
      expect(client.secret).to eql('SECRET')
    end
  end

  describe '#balance' do
    let(:api_balance_response){ double }
    let(:balance_object){ double }

    before do
      net.stub(:post).and_return(api_balance_response)
      mapper.stub(:map_balance).and_return(balance_object)
      client.balance
    end

    it 'requests the balance from the API' do
      expect(net).to have_received(:post).with('balance')
    end

    it 'maps the API response to a Balance object' do
      expect(mapper).to have_received(:map_balance).with(api_balance_response)
    end

    it 'returns the mapped object' do
      expect(client.balance).to eq(balance_object)
    end
  end

  describe '#orders' do
    let(:api_orders_response){ double }
    let(:order_object){ double }

    before do
      net.stub(:post).and_return(api_orders_response)
      mapper.stub(:map_orders).and_return([order_object])
      client.orders
    end

    it 'requests open orders from the API' do
      expect(net).to have_received(:post).with('open_orders')
    end

    it 'maps the API response to an array of Order objects' do
      expect(mapper).to have_received(:map_orders).with(api_orders_response)
    end
  end

  describe 'buy!' do
    let(:api_buy_response){ double }
    let(:order_object){ double }

    before do
      net.stub(:post).and_return(api_buy_response)
      mapper.stub(:map_order).and_return(order_object)
    end

    it 'submits a buy order to the API' do
      client.buy!(BigDecimal('100'), BigDecimal('1'))
      expect(net).to have_received(:post).with('buy', { amount: '100.0', price: '1.0' })
    end

    it 'maps the API response to an Order object' do
      client.buy!(BigDecimal('100'), BigDecimal('1'))
      expect(mapper).to have_received(:map_order).with(api_buy_response)
    end

    it 'wraps exceptions in its own class' do
      net.stub(:post).and_raise(StandardError)
      expect{ client.buy!(BigDecimal('100'), BigDecimal('1')) }.to raise_error(Bitstampede::StandardError)
    end
  end

  describe 'sell!' do
    let(:api_sell_response){ double }
    let(:order_object){ double }

    before do
      net.stub(:post).and_return(api_sell_response)
      mapper.stub(:map_order).and_return(order_object)
      client.sell!(BigDecimal('100'), BigDecimal('1'))
    end

    it 'submits a sell order to the API' do
      expect(net).to have_received(:post).with('sell', { amount: '100.0', price: '1.0' })
    end

    it 'maps the API response to an Order object' do
      expect(mapper).to have_received(:map_order).with(api_sell_response)
    end

    it 'wraps exceptions in its own class' do
      net.stub(:post).and_raise(StandardError)
      expect{ client.sell!(BigDecimal('100'), BigDecimal('1')) }.to raise_error(Bitstampede::StandardError)
    end
  end

  describe 'cancel' do
    let(:api_cancel_response){ double }

    before do
      net.stub(:post).and_return(api_cancel_response)
      mapper.stub(:map_cancel).and_return(true)
      client.cancel(1234)
    end

    it 'submits a cancel order to the API' do
      expect(net).to have_received(:post).with('cancel_order', { id: '1234' })
    end

    it 'maps the API response to a boolean' do
      expect(mapper).to have_received(:map_cancel).with(api_cancel_response)
    end

    it 'wraps exceptions in its own class' do
      net.stub(:post).and_raise(StandardError)
      expect{ client.cancel(123) }.to raise_error(Bitstampede::StandardError)
    end
  end
end
