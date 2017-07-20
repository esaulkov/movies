# coding: utf-8
# frozen_string_literal: true

require 'csv'
require 'yaml'

module Movies
  class MovieCollection    
    DATA_FOLDER = 'data'
    BUDGETS_FILE = "#{DATA_FOLDER}/budgets.yml"
    DEFAULT_PATH = "#{DATA_FOLDER}/movies.txt"
    INFO_FILE = "#{DATA_FOLDER}/info.yml"

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

    def additional_info
      raise ArgumentError, 'File not found!' unless File.exist?(INFO_FILE)
      @additional_info ||= YAML.load_file(INFO_FILE)
    end

    def all
      movies
    end

    def budgets
      raise ArgumentError, 'File not found!' unless File.exist?(BUDGETS_FILE)
      @budgets ||= YAML.load_file(BUDGETS_FILE)
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

    def size
      movies.size
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
