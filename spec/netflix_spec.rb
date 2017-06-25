# coding: utf-8

require 'spec_helper'
require 'movies/netflix'

describe Netflix do
  let! (:collection) { MovieCollection.new }
  let (:netflix) { Netflix.new(collection) }

  describe '#show' do
    subject { netflix.show(genre: 'Comedy', period: :classic) }

    context 'when balance is positive' do
      before(:each) { netflix.pay(100) }

      it 'filters movies by params' do
        is_expected.to match('классический')
        is_expected.to match('Comedy')
      end

      it 'reduces amount of money' do
        expect { subject }.to change { netflix.balance }.from(100).to(98.5)
      end
    end

    context 'when balance is negative' do
      it 'raises an exception' do
        expect { subject }.to raise_error(
          ArgumentError, a_string_starting_with('Не хватает денег')
        )
      end
    end
  end

  describe '#pay' do
    it 'increases amount of money' do
      expect { netflix.pay(100) }.to change { netflix.balance }.from(0).to(100)
    end
  end

  describe '#how_much?' do
    subject { netflix.how_much?('Seven Samurai') }

    it 'returns movie price' do
      is_expected.to eq(1.5)
    end
  end
end
