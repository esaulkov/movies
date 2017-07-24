# coding: utf-8

RSpec::Matchers.define_negated_matcher :not_match, :match

describe Movies::Cinema::Netflix do
  let! (:collection) { Movies::MovieCollection.new }
  let (:netflix) { described_class.new(collection) }

  describe '#by_country' do
    subject { netflix.by_country }

    it { is_expected.to be_an_instance_of(Movies::Cinema::CountrySelection) }
  end

  describe '#by_genre' do
    subject { netflix.by_genre }

    it { is_expected.to be_an_instance_of(Movies::Cinema::GenreSelection) }
  end

  describe '#define_filter' do
    subject do
      netflix.define_filter(:my_wish) do |movie|
        movie.year > 2000 && movie.producer == 'Christopher Nolan'
      end
    end

    it 'saves the filter in instance attribute' do
      expect(subject).to be_an_instance_of(Proc)
    end
  end

  describe '#show' do
    subject { netflix.show(genre: 'Comedy', period: :classic) }

    context 'when balance is positive' do
      before(:each) { netflix.pay(100) }

      it 'filters movies by params' do
        is_expected.to match('классический').and match('Comedy')
      end

      it 'reduces amount of money' do
        expect { subject }.to change(netflix, :balance)
          .from(Money.new(10000)).to(Money.new(9850))
      end

      context 'when params is a block' do
        subject do
          netflix.show do |movie|
            movie.actors.include?('Chris Pratt') && movie.genre.include?('Adventure')
          end
        end

        it 'filters movies by condition' do
          is_expected.to match('Guardians of the Galaxy')
        end
      end

      context 'when params is a saved filter' do
        before(:each) do
          netflix.define_filter(:my_wish) do |movie, period|
            movie.period == period && movie.genre.include?('History')
          end
        end

        it 'can work with saved filters' do
          expect(netflix.show(my_wish: :new)).to match('новинка').and match('History')
        end

        it 'can use child filters' do
          netflix.define_filter(:child, from: :my_wish, arg: :classic)

          expect(netflix.show(child: true)).to match('классический фильм').and match('History')
        end

        it 'can negate the filter' do
          netflix.define_filter(:child, from: :my_wish, arg: :classic)

          expect(netflix.show(child: false)).to not_match('классический фильм').or not_match('History')
        end

        it 'can work with many filters' do
          netflix.define_filter(:my_other_wish) do |movie|
            movie.genre.include?('Biography')
          end

          expect(netflix.show(my_wish: :modern, my_other_wish: true))
            .to match('современное кино').and match('History').and match('Biography')
        end

        it 'can work with both types of filters' do
          expect(netflix.show(my_wish: :modern, actors: 'Mel Gibson'))
            .to match('современное кино').and match('Mel Gibson')
        end
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
      Movies::Cinema::Netflix.take('Bank')
      expect { netflix.pay(75) }
        .to change(Movies::Cinema::Netflix, :cash).from('$0.00').to('$75.00')
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
