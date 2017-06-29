# coding: utf-8
# frozen_string_literal: true

class DummyClass
  include Cashbox
end

describe Cashbox do
  let(:dummy) { DummyClass.new }

  describe '.cash' do
    it 'returns sum of money'
  end

  describe '.put_money' do
    it 'moves sum of money to cashbox'
  end

  describe '.take' do
    it 'set amount of money to zero if it is called by bank'
    it 'raises error in other case'
  end
end
