# coding: utf-8

describe Movies::Netflix do
  let! (:collection) { Movies::MovieCollection.new }
  let (:netflix) { Movies::Netflix.new(collection) }

  describe '#define_filter' do
    it 'saves the filter in instance attribute' do
      netflix.define_filter(:my_wish) do |movie|
        movie.year > 2000 && movie.producer == 'Christopher Nolan'
      end

      expect(netflix.filters).to include(my_wish: an_instance_of(Proc))
    end
  end

  describe '#show' do
    subject { netflix.show(genre: 'Comedy', period: :classic) }

    context 'when balance is positive' do
      before(:each) { netflix.pay(100) }

      it 'filters movies by params' do
        is_expected.to match('классический').and match('Comedy')
      end

      it 'can accept block as params' do
        res = netflix.show { |movie| movie.actors.include?('Chris Pratt') && movie.genre.include?('Adventure') }
        expect(res).to match('Guardians of the Galaxy')
      end

      it 'can work with saved filters' do
        netflix.define_filter(:my_wish) do |movie, year|
          movie.year > year && movie.genre.include?('History')
        end

        expect(netflix.show(my_wish: 2000)).to match('новинка').and match('History')
      end

      it 'can use child filters' do
        netflix.define_filter(:my_wish) do |movie, period|
          movie.period == period && movie.genre.include?('History')
        end
        netflix.define_filter(:child, from: :my_wish, arg: :classic)

        expect(netflix.show(child: true)).to match('классический фильм').and match('History')
      end

      it 'reduces amount of money' do
        expect { subject }.to change(netflix, :balance)
          .from(Money.new(10000)).to(Money.new(9850))
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
      expect { netflix.pay(100) }.to change(netflix, :balance).from(Money.new(0)).to(Money.new(10000))
    end

    it 'could not accept negative value' do
      expect { netflix.pay(-100) }.to raise_error(
        ArgumentError, 'Нельзя пополнить баланс на отрицательную сумму'
      )
    end

    it 'increases amount in cashbox' do
      Movies::Netflix.take('Bank')
      expect { netflix.pay(75) }.to change(Movies::Netflix, :cash).from('$0.00').to('$75.00')
    end
  end

  describe '#how_much?' do
    it 'returns movie price' do
      expect(netflix.how_much?('City Lights')).to eq('$1.00')
      expect(netflix.how_much?('Seven Samurai')).to eq('$1.50')
      expect(netflix.how_much?('Fight Club')).to eq('$3.00')
      expect(netflix.how_much?('Interstellar')).to eq('$5.00')
      expect { netflix.how_much?('Vinni Pooh') }.to raise_error(
        ArgumentError, 'Такой фильм не найден'
      )
    end
  end
end
