# coding: utf-8

require 'csv'
require 'date'
require_relative 'movie'

class MovieCollection
  DEFAULT_PATH = 'movies.txt'.freeze
  NUMBER_PARAMS = %i(length rating).freeze
  MULTIPLE_PARAMS = %i(actors genres).freeze

  attr_accessor :movies

  def initialize(path = nil)
    movies_file = path || DEFAULT_PATH
    abort("This file doesn't exist") unless File.file?(movies_file)

    @movies = CSV.read(movies_file, col_sep: '|', headers: Movie::PARAMS).map do |row|
      Movie.new(row.to_h)
    end
  end

  def all
    movies
  end

  def filter(params)
    movies.select do |movie|
      params.all? { |key, value| movie.send(key).include?(value) }
    end
  end

  def sort_by(field)
    if NUMBER_PARAMS.include?(field.to_sym)
      movies.sort_by { |movie| movie.send(field.to_sym).to_f }.reverse
    else
      movies.sort_by(&field.to_sym)
    end
  end

  def stats(field)
    if MULTIPLE_PARAMS.include?(field.to_sym)
      statistic = movies.map { |movie| movie.send("#{field.to_s}_list") }.flatten
    elsif field.to_sym == :month
      statistic = movies
        .reject { |movie| movie.release.size < 5 }
        .map { |movie| Date::MONTHNAMES[Date.strptime(movie.release, '%Y-%m').month] }
        .compact
    else
      statistic = movies.map(&field.to_sym)
    end

    counts = statistic.each_with_object(Hash.new(0)) do |key, counts|
      counts[key] += 1
    end

    if field.to_sym == :month
      counts.sort_by { |key, _| Date.strptime(key, '%B') }
    else
      counts.sort
    end.to_h
  end
end
