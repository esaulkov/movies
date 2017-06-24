# coding: utf-8

require 'spec_helper'
require 'movies/modern_movie'

describe ModernMovie do
  describe '#to_s' do
    let (:movie) do
      ModernMovie.new(
        name: 'The best movie',
        producer: "It's me",
        actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
        year: '1980'
      )
    end
    subject { movie.to_s }

    it 'shows actors names' do
      is_expected.to include('Benedict Cumberbatch, Bill Nighy, Keyra Knightley')
    end

    it 'specifies movie as modern' do
      is_expected.to include('современное кино')
    end
  end
end
