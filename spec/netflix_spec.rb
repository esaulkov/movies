# coding: utf-8

require 'spec_helper'
require 'movies/netflix'

describe Netflix do
  let! (:collection) { MovieCollection.new }
  let (:netflix) { Netflix.new(collection) }

  describe '#show' do
    subject { netflix.show(genre: 'Comedy', period: :classic) }

    it 'filters movies by params' do
      is_expected.to be an_instance_of(ClassicMovie)
      expect(subject.genres).to include('Comedy')
    end

    it 'reduces amount of money' do
      expect { subject }.to change { netflix.balance }.from(0).to(-1.5)
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
