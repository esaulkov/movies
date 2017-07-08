# coding: utf-8
# frozen_string_literal: true

require 'csv'

module Movies
  class MovieCollection
    DEFAULT_PATH = 'movies.txt'

    include Enumerable

    attr_reader :movies

    def initialize(path = nil)
      movies_file = path || DEFAULT_PATH
      abort("This file doesn't exist") unless File.file?(movies_file)

      @movies = CSV.read(movies_file, col_sep: '|', headers: Movie::PARAMS).map do |row|
        params = row.to_h.merge(collection: self)
        Movie.create(params)
      end
    end

    def all
      movies
    end

    def each(&block)
      movies.each(&block)
    end

    def filter(params)
      movies.select do |movie|
        params.all? do |arg|
          if arg.is_a?(Proc)
            arg.call(movie)
          else
            key, value = arg.is_a?(Hash) ? arg.flatten : arg
            movie.matches?(key, value)
          end
        end
      end
    end

    def genres
      @genres ||= movies.flat_map(&:genres).uniq
    end

    def sort_by(field)
      movies.sort_by(&field.to_sym)
    end

    def stats(field)
      statistic = movies.map(&field.to_sym).flatten.compact
      counts = statistic.each_with_object(Hash.new(0)) do |key, counter|
        counter[key] += 1
      end

      counts.sort.to_h
    end
  end
end
