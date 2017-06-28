# coding: utf-8

describe AncientMovie do
  describe '#to_s' do
    let (:movie) do
      AncientMovie.new(
        name: 'The best movie',
        producer: "It's me",
        actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
        year: '1933'
      )
    end
    subject { movie.to_s }

    it 'specifies movie as ancient' do
      is_expected.to start_with('The best movie - старый фильм (1933 год)')
    end
  end
end
