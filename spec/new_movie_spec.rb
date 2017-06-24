# coding: utf-8

require 'spec_helper'
require 'movies/new_movie'

describe NewMovie, type: :model do
  describe '#to_s' do
    let (:movie) do
      NewMovie.new(
        name: 'The best movie',
        producer: "It's me",
        actors: 'Benedict Cumberbatch, Bill Nighy, Keyra Knightley',
        year: '2012'
      )
    end
    subject { movie.to_s }

    it 'shows number of years from release' do
      years_ago = Date.today.year - '2012'.to_i
      is_expected.to include(years_ago.to_s)
    end

    it 'specifies movie as new' do
      is_expected.to include('новинка')
    end
  end
end
