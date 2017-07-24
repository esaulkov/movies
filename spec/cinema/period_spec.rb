# coding: utf-8
# frozen_string_literal: true

describe Movies::Cinema::Period do
  let(:collection) { Movies::MovieCollection.new }
  let(:cinema) do
    Movies::Cinema::Theatre.new(collection) do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
    end
  end

  let(:period) do
    described_class.new('09:00'..'11:00', cinema) do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :red, :blue
    end
  end

  describe '#new' do
    subject { period }

    it { is_expected.to have_attributes(filter: {genre: 'Comedy', year: 1900..1980}) }
    it { is_expected.to have_attributes(cost: 10) }
    it { is_expected.to have_attributes(halls: cinema.halls) }

    context 'when hall is not found' do
      subject do
        described_class.new('09:00'..'11:00', cinema) do
          description 'Утренний сеанс'
          filters genre: 'Comedy', year: 1900..1980
          price 10
          hall :black
        end
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Нет такого зала (black) в кинотеатре')
      end
    end
  end

  describe '#tickets' do
    subject { period.tickets }

    it 'returns the number of seats for this show' do
      is_expected.to eq(150)
    end
  end

  describe '#to_s' do
    subject { period.to_s }

    it 'returns the show time and hall titles' do
      is_expected.to eq('Утренний сеанс: 09:00 - 11:00, Красный зал, Синий зал')
    end
  end
end
