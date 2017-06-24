# coding: utf-8

require 'spec_helper'
require 'movies/theatre'

describe Theatre do
  let(:theatre) { Theatre.new(collection) }

  describe '#show' do
    context 'when it is morning' do
      subject { theatre.show('08:30') }

      it 'shows ancient movie' do
        is_expected.to include('старый фильм')
      end
    end
    context 'when it is day' do
      subject { theatre.show('13:15') }

      it 'shows comedy or adventure' do
        is_expected.to include('Comedy').or include('Adventure')
      end
    end
    context 'when it is evening' do
      subject { theatre.show('20:00') }

      it 'shows drama or horror' do
        is_expected.to include('Drama').or include('Horror')
      end
    end
  end

  describe '#when?' do
    subject { theatre.when?('Seven Samurai') }

    it 'returns time according movie genre' do
      is_expected.to eq('вечером')
    end
  end
end
