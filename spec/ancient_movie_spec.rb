# coding: utf-8

require 'spec_helper'
require 'movies/ancient_movie'

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

    it 'contents movie year' do
      is_expected.to include('1933')
    end

    it 'specifies movie as ancient' do
      is_expected.to include('старый фильм')
    end
  end
end
