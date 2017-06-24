# coding: utf-8

require 'spec_helper'
require 'movies/classic_movie'

describe ClassicMovie do
  describe '#to_s' do
    let (:movie) do
      ClassicMovie.new(
        name: 'The best movie',
        producer: "It's me",
        actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
        year: '1964'
      )
    end
    subject { movie.to_s }

    it 'shows producer name' do
      is_expected.to include("It's me")
    end

    it 'specifies movie as classic' do
      is_expected.to include('классический фильм')
    end
  end
end
