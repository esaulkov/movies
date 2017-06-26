# coding: utf-8
# frozen_string_literal: true

require 'shared_examples_for_movies'

describe MovieCollection do
  describe '#new' do
    subject { MovieCollection.new }

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
end
