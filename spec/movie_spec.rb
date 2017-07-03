# coding: utf-8
# frozen_string_literal: true

shared_examples 'create instance of proper class' do |period, class_name|
  let(:params) do
    {
      name: 'The best movie',
      producer: "It's me",
      actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
      year: rand(period).to_s
    }
  end

  it "should create an instance of #{class_name}" do
    expect(subject).to be_an_instance_of(class_name)
  end
end

describe Movies::Movie do
  describe '#create' do
    subject { Movies::Movie.create(params) }

    context 'when year is before 1946' do
      it_behaves_like 'create instance of proper class', 1901..1945, Movies::AncientMovie
    end

    context 'when year is in range 1946-1968' do
      it_behaves_like 'create instance of proper class', 1946..1968, Movies::ClassicMovie
    end

    context 'when year is in range 1969-2000' do
      it_behaves_like 'create instance of proper class', 1969..2000, Movies::ModernMovie
    end

    context 'when year is after 2000' do
      it_behaves_like 'create instance of proper class', 2001..Date.today.year, Movies::NewMovie
    end

    context 'when year is undefined' do
      it_behaves_like 'create instance of proper class', nil, Movies::Movie
    end
  end

  describe '#matches?' do
    let(:movie) do
      Movies::Movie.create(
        name: 'Pulp Fiction',
        producer: 'Quentin Tarantino',
        year: '1994',
        release: '1994-10-14',
        length: '154 min',
        rating: '8.9',
        genres: 'Crime,Drama',
        actors: 'John Travolta,Uma Thurman,Samuel L. Jackson'
      )
    end

    it 'returns TRUE if movie attributes match params' do
      expect(movie.matches?(:year, 1994)).to be_truthy
      expect(movie.matches?(:year, 1991..1994)).to be_truthy
      expect(movie.matches?(:rating, 8.9)).to be_truthy
      expect(movie.matches?(:length, 154)).to be_truthy
      expect(movie.matches?(:genre, 'Drama')).to be_truthy
      expect(movie.matches?(:genres, ['Adventure', 'Drama'])).to be_truthy
      expect(movie.matches?(:actors, 'Uma Thurman')).to be_truthy
    end

    it 'returns FALSE unless movie attributes match params' do
      expect(movie.matches?(:year, 2015)).to be_falsey
      expect(movie.matches?(:year, '1994')).to be_falsey
      expect(movie.matches?(:rating, '8.9')).to be_falsey
      expect(movie.matches?(:genre, 'Adventure')).to be_falsey
      expect(movie.matches?(:genres, 'Crime,Action')).to be_falsey
      expect(movie.matches?(:genre, ['Action', 'History'])).to be_falsey
      expect(movie.matches?(:actors, 'Tom Hanks')).to be_falsey
      expect(movie.matches?(:actors, 'John Travolta ||')).to be_falsey
    end
  end

  describe '#to_s' do
    let (:movie) do
      Movies::Movie.new(
          name: 'The best movie',
          producer: "It's me",
          actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley'
      )
    end
    subject { movie.to_s }

    it 'contents movie name' do
      is_expected.to include(movie.name)
    end
  end
end
