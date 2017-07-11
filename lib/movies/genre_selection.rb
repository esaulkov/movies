# coding: utf-8
# frozen_string_literal: true

module Movies
  class GenreSelection
    def initialize(collection)
      @collection = collection

      @collection.genres.each do |genre|
        define_singleton_method genre.downcase.tr('-', '_').to_s do
          @collection.filter(genre: genre)
        end
      end
    end
  end
end
