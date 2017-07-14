# coding: utf-8
# frozen_string_literal: true

module Movies
  class ClassicMovie < Movie
    def price
      Money.new(150)
    end

    def to_s
      "#{name} - классический фильм (#{genres.join(', ')}),"\
      " режиссер #{producer}, снял также #{producer_movies}"
    end

    private

    def producer_movies
      @collection
        .filter(producer: producer)
        .reject { |m| m == self }
        .map(&:name)
        .join(', ')
    end
  end
end
