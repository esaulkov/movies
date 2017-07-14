# coding: utf-8

shared_examples 'buy_ticket' do |time, price, hall = nil|
  subject { theatre.buy_ticket(time, hall) }

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
  let(:theatre) do
    Movies::Theatre.new(collection) do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      period '09:00'..'11:00' do
        description 'Утренний сеанс'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red
      end

      period '11:00'..'16:00' do
        description 'Спецпоказ'
        title 'The Terminator'
        price 50
        hall :red
      end

      period '10:00'..'15:00' do
        description 'Дневной сеанс'
        filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
        price 20
        hall :blue
      end

      period '16:00'..'20:00' do
        description 'Вечерний сеанс'
        filters year: 1900..1945, exclude_country: 'USA'
        price 30
        hall :red, :blue
      end
    end
  end

  describe '#new' do
    subject { Movies::Theatre.new(collection) { return 'It is a block!' } }

    it 'can accept a block' do
      is_expected.to eq('It is a block!')
    end

    context 'when schedule is invalid' do
      subject do
        Movies::Theatre.new(collection) do
          hall :red, title: 'Красный зал', places: 100
          period '09:00'..'11:00' do
            description 'Утренний сеанс'
            title 'The Terminator'
            price 50
            hall :red
          end

          period '10:00'..'16:00' do
            description 'Спецпоказ'
            title 'The Terminator'
            price 50
            hall :red
          end
        end
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, /Расписание некорректно/)
      end
    end

    context 'when schedule is valid' do
      it "doesn't raise an error" do
        expect { subject }.to_not raise_error
      end
    end
  end

  describe '#buy_ticket' do
    context 'when there is one seance' do
      it_behaves_like 'buy_ticket', '09:20', 10
      it_behaves_like 'buy_ticket', '15:45', 50
      it_behaves_like 'buy_ticket', '18:05', 30
    end

    context 'when there are no seances' do
      subject { theatre.buy_ticket('03:40') }

      it 'raises error' do
        expect { subject }.to raise_error(
          ArgumentError, 'Кинотеатр закрыт, касса не работает'
        )
      end
    end

    context 'when there are many seances in the time' do
      context 'when hall is defined' do
        it_behaves_like 'buy_ticket', '14:00', 20, :blue
      end

      context 'when hall is not defined' do
        subject { theatre.buy_ticket('14:00') }

        it 'raises error' do
          expect { subject }.to raise_error(
            ArgumentError, 'В это время проходят несколько сеансов. Укажите зал (red, blue) при покупке билета'
          )
        end
      end
    end
  end

  describe '#show' do
    context 'when movie name is not defined' do
      subject { theatre.show('09:30') }

      it 'shows movie according defined filter' do
        is_expected.to include('Comedy')
      end
    end
    context 'when movie name is defined in schedule' do
      subject { theatre.show('15:15') }

      it 'shows this movie' do
        is_expected.to include('The Terminator')
      end
    end
    context "when we use 'exclude' in filter" do
      subject { theatre.show('19:00') }

      it 'excludes movies by this parameter' do
        is_expected.to_not include('USA')
      end
    end

    context 'when there are no show' do
      subject { theatre.show('02:00') }

      it 'shows error message' do
        is_expected.to eq('Кинотеатр закрыт, касса не работает')
      end
    end
  end

  describe '#when?' do
    it 'returns time according movie name, genre or year' do
      expect(theatre.when?('The Sting')).to eq('Утренний сеанс: 09:00 - 11:00, Красный зал')
      expect(theatre.when?('The Dark Knight Rises'))
        .to eq('Дневной сеанс: 10:00 - 15:00, Синий зал')
      expect(theatre.when?('The Terminator')).to eq('Спецпоказ: 11:00 - 16:00, Красный зал')
      expect(theatre.when?('M')).to eq('Вечерний сеанс: 16:00 - 20:00, Красный зал, Синий зал')
      expect(theatre.when?('The Wizard of Oz')).to eq('этот фильм в нашем театре не транслируется')
    end
  end
end
