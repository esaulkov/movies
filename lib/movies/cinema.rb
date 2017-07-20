# coding: utf-8
# frozen_string_literal: true

module Movies
  module Cinema
    class Cinema
      def initialize(collection)
        @collection = collection
      end

      private

      def choice(movies)
        movies.sort_by { |movie| movie.rating * rand }.last
      end

      def display(movie)
        "Now showing: #{movie}"
      end
    end

    require 'movies/cinema/cashbox'
    require 'movies/cinema/country_selection'
    require 'movies/cinema/genre_selection'
    require 'movies/cinema/hall'
    require 'movies/cinema/period'
    require 'movies/cinema/netflix'
    require 'movies/cinema/theatre'
  end
end
