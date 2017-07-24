# coding: utf-8
# frozen_string_literal: true

describe Movies::Cinema::CountrySelection do
  let(:collection) { Movies::MovieCollection.new }
  let(:selection) { described_class.new(collection) }

  context 'when movies from the country are in collection' do
    subject { selection.usa }

    it 'returns a list of movies' do
      is_expected.to all( be_a(Movies::Movie) )
    end

    it 'can work with double names' do
      expect(selection.south_korea).to all( be_a(Movies::Movie) )
    end
  end

  context 'when the country is unknown' do
    subject { selection.atlantida }

    it 'raises error' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end
end
