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
      subject.balance
    end

    it 'requests the balance from the API' do
      expect(net).to have_received(:post).with('balance')
    end

    it 'maps the API response to a Balance object' do
      expect(mapper).to have_received(:map_balance).with(api_balance_response)
    end

    it 'returns the mapped object' do
      expect(subject.balance).to eq(balance_object)
    end
  end

  describe '#orders' do
    let(:api_orders_response){ double }
    let(:order_object){ double }

    before do
      net.stub(:post).and_return(api_orders_response)
      mapper.stub(:map_orders).and_return([order_object])
      subject.orders
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
      subject.buy!(BigDecimal('100'), BigDecimal('1'))
      expect(net).to have_received(:post).with('buy', { amount: '100.0', price: '1.0' })
    end

    it 'maps the API response to an Order object' do
      subject.buy!(BigDecimal('100'), BigDecimal('1'))
      expect(mapper).to have_received(:map_order).with(api_buy_response)
    end

    it 'wraps exceptions in its own class' do
      net.stub(:post).and_raise(StandardError)
      expect{ subject.buy!(BigDecimal('100'), BigDecimal('1')) }.to raise_error(Bitstampede::StandardError)
    end
  end

  describe 'sell!' do
    let(:api_sell_response){ double }
    let(:order_object){ double }

    before do
      net.stub(:post).and_return(api_sell_response)
      mapper.stub(:map_order).and_return(order_object)
      subject.sell!(BigDecimal('100'), BigDecimal('1'))
    end

    it 'submits a sell order to the API' do
      expect(net).to have_received(:post).with('sell', { amount: '100.0', price: '1.0' })
    end

    it 'maps the API response to an Order object' do
      expect(mapper).to have_received(:map_order).with(api_sell_response)
    end

    it 'wraps exceptions in its own class' do
      net.stub(:post).and_raise(StandardError)
      expect{ subject.sell!(BigDecimal('100'), BigDecimal('1')) }.to raise_error(Bitstampede::StandardError)
    end
  end

  describe 'cancel' do
    let(:api_cancel_response){ double }

    before do
      net.stub(:post).and_return(api_cancel_response)
      mapper.stub(:map_cancel).and_return(true)
      subject.cancel(1234)
    end

    it 'submits a cancel order to the API' do
      expect(net).to have_received(:post).with('cancel_order', { id: '1234' })
    end

    it 'maps the API response to a boolean' do
      expect(mapper).to have_received(:map_cancel).with(api_cancel_response)
    end
  end
end
