# coding: utf-8

shared_examples 'buy_ticket' do |time, price|
  subject { theatre.buy_ticket(time) }

  it 'returns a ticket' do
    is_expected.to start_with('Вы купили билет')
  end

  it 'changes amount of money in cashbox' do
    expect { subject }.to change(theatre, :cash)
      .from('$0.00').to(Money.new(price * 100).format)
  end
end

describe Movies::Theatre do
  let! (:collection) { Movies::MovieCollection.new }
  let(:theatre) { Movies::Theatre.new(collection) }

  describe '#buy_ticket' do
    context 'when it is morning' do
      it_behaves_like 'buy_ticket', '09:20', 3
    end

    context 'when it is day' do
      it_behaves_like 'buy_ticket', '15:45', 5
    end

    context 'when it is evening' do
      it_behaves_like 'buy_ticket', '20:05', 10
    end

    context 'when it is night' do
      subject { theatre.buy_ticket('03:40') }

      it 'raises error' do
        expect { subject }.to raise_error(
          ArgumentError, 'Кинотеатр закрыт, касса не работает'
        )
      end
    end
  end

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
