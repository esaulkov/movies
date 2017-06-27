# coding: utf-8
# frozen_string_literal: true

require 'shared_examples_for_movies'

describe Movie do
  describe '#create' do
    subject { Movie.create(params) }

    context 'when year is before 1946' do
      it_behaves_like 'create instance of proper class', 1901..1945, AncientMovie
    end

    context 'when year is in range 1946-1968' do
      it_behaves_like 'create instance of proper class', 1946..1968, ClassicMovie
    end

    context 'when year is in range 1969-2000' do
      it_behaves_like 'create instance of proper class', 1969..2000, ModernMovie
    end

    context 'when year is after 2000' do
      it_behaves_like 'create instance of proper class', 2001..Date.today.year, NewMovie
    end

    context 'when year is undefined' do
      it_behaves_like 'create instance of proper class', nil, Movie
    end
  end

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
