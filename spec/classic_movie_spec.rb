# coding: utf-8

describe Movies::ClassicMovie do
  describe '#to_s' do
    let (:collection) { Movies::MovieCollection.new }
    let (:movie) do
      Movies::ClassicMovie.new(
        name: 'The best movie',
        producer: "It's me",
        actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
        year: '1964',
        collection: collection
      )
    end
    let (:second_movie) do
      Movies::ClassicMovie.new(
        name: 'The worth movie',
        producer: "It's me",
        actors: 'Andrey Chadov, Marina Alexandrova',
        year: '1974',
        collection: collection
      )
    end
    subject { movie.to_s }

    it 'shows another producer movies' do
      allow(collection).to receive(:filter).and_return([movie, second_movie])

      is_expected.to end_with('снял также The worth movie')
    end

    it 'shows producer name' do
      is_expected.to include("It's me")
    end

    it 'specifies movie as classic' do
      is_expected.to include('классический фильм')
    end
  end
end
