# coding: utf-8
# frozen_string_literal: true

class DummyClass
  include Cashbox
end

describe Cashbox do
  let(:dummy) { DummyClass.new }

  describe '.cash' do
    subject { dummy.cash }
    it 'returns sum of money' do
      is_expected.to eq(0)
    end
  end

  describe '.put_money' do
    subject { dummy.put_money(50) }

    it 'moves sum of money to cashbox' do
      expect { subject }.to change { dummy.cash }.from(0).to(50)
    end
  end

  describe '.take' do
    before(:each) { dummy.put_money(100) }

    it 'set amount of money to zero if it is called by bank' do
      expect { dummy.take('Bank') }.to change { dummy.cash }.from(100).to(0)
      expect(dummy.take('Bank')).to eq('Проведена инкассация')
    end

    it 'raises error in other case' do
      expect { dummy.take('Gang') }.to raise_error(
        ArgumentError, 'Оставайтесь на месте, наряд уже выехал!'
      )
    end
  end
end
