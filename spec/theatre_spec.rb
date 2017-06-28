# coding: utf-8

describe Theatre do
  let! (:collection) { MovieCollection.new }
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

    context 'when it is night' do
      subject { theatre.show('02:00') }

      it 'shows error message' do
        is_expected.to eq('Извините, ночью сеансов нет.')
      end
    end
  end

  describe '#when?' do
    it 'returns time according movie genre or year' do
      expect(theatre.when?('The Wizard of Oz')).to eq('утром или днем')
      expect(theatre.when?('Groundhog Day')).to eq('днем')
      expect(theatre.when?('Seven Samurai')).to eq('вечером')
      expect(theatre.when?('The Terminator')).to eq('этот фильм в нашем театре не транслируется')
    end
  end
end
