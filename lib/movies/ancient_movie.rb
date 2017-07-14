# coding: utf-8
# frozen_string_literal: true

module Movies
  class AncientMovie < Movie
    def price
      Money.new(100)
    end

    def to_s
      "#{name} - старый фильм (#{year} год), жанры: #{genres.join(', ')}"
    end
  end
end
