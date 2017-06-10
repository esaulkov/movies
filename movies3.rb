#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'date'
require 'ostruct'

DEFAULT_PATH = 'movies.txt'.freeze
MOVIE_PARAMS = %w(link name year country release genres length rating producer actors).freeze

def movies_list(films)
  films.map do |movie|
    "#{movie.name} (#{movie.release}; #{movie.genres.gsub(/,/, '/')}) - #{movie.length}"
  end.join("\n")
end

search_name = ARGV[0]
movies_file = ARGV[1] || DEFAULT_PATH
abort("This file doesn't exist") unless File.file?(movies_file)

movies = CSV.read(movies_file, col_sep: '|').map do |row|
  OpenStruct.new(MOVIE_PARAMS.zip(row).to_h)
end

sorted = movies.sort_by { |movie| movie.length.to_i }.last(5).reverse

puts 'The five longest movies are:'
puts movies_list(sorted)

comedies = movies
  .select { |movie| movie.genres.include?('Comedy') }
  .sort_by(&:release)
  .first(10)

puts "\nThe first ten comedies are:"
puts movies_list(comedies)

producers = movies
  .collect(&:producer)
  .uniq
  .sort_by { |producer| producer.split.last }

puts "\nList of producers:"
puts producers

foreign_movies = movies.count { |movie| movie.country != 'USA' }

puts "\nCount of non-USA movies - #{foreign_movies}"

puts "\nStats by month"

statistic = movies
  .reject { |movie| movie.release.size < 5 }
  .map { |movie| Date.strptime(movie.release, '%Y-%m').month }
  .compact

counts = statistic.each_with_object(Hash.new(0)) do |month_number, counts|
  counts[month_number] += 1
end

counts.sort.to_h.each do |month_number, count|
  puts "#{Date::MONTHNAMES[month_number]} - #{count}"
end
