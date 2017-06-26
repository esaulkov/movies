# coding: utf-8

describe Movie, type: :model do
  describe '#to_s' do
    let (:movie) do
      Movie.new(
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
