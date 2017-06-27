# coding: utf-8
# frozen_string_literal: true

class Cinema
  def initialize(collection)
    @collection = collection
  end

  private

  def choice(movies)
    movies.sort_by { |movie| movie.rating * rand }.last
  end

  def translate(movie)
    "Now showing: #{movie}"
  end
end
