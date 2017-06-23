# coding: utf-8

require 'csv'
require_relative 'movie'

class MovieCollection
  DEFAULT_PATH = 'movies.txt'.freeze

  attr_reader :movies

  def initialize(path = nil)
    movies_file = path || DEFAULT_PATH
    abort("This file doesn't exist") unless File.file?(movies_file)

    @movies = CSV.read(movies_file, col_sep: '|', headers: Movie::PARAMS).map do |row|
      params = row.to_h.merge(collection: self)
      case params[:year].to_i
      when 1900..1945 then AncientMovie.new(params)
      when 1946..1968 then ClassicMovie.new(params)
      when 1969..2000 then ModernMovie.new(params)
      when 2000..Date.today.year then NewMovie.new(params)
      else Movie.new(params)
      end
    end
  end

  def all
    movies
  end

  def filter(params)
    movies.select do |movie|
      params.all? { |key, value| movie.matches?(key, value) }
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
    counts = statistic.each_with_object(Hash.new(0)) do |key, counts|
      counts[key] += 1
    end

    counts.sort.to_h
  end
end
