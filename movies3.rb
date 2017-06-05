#!/usr/bin/env ruby
# coding: utf-8

require 'date'

DEFAULT_PATH = 'movies.txt'.freeze
MOVIE_PARAMS = %i[link name year country release genres length rating producer actors].freeze

def movies_list(films)
  films.map do |movie|
    "#{movie[:name]} (#{movie[:release]}; #{movie[:genres].gsub(/,/, '/')}) - #{movie[:length]}"
  end.join("\n")
end

search_name = ARGV[0]
movies_file = ARGV[1] || DEFAULT_PATH
abort("This file doesn't exist") unless File.file?(movies_file)

movies = File.open(movies_file, 'r').map do |line|
  MOVIE_PARAMS.zip(line.split('|')).to_h
end

sorted = movies.sort_by { |movie| movie[:length].to_i }.last(5).reverse

puts 'The five longest movies are:'
puts movies_list(sorted)

comedies = movies
  .select { |movie| movie[:genres].include?('Comedy') }
  .sort_by { |movie| movie[:release] }
  .first(10)

puts "\nThe first ten comedies are:"
puts movies_list(comedies)

producers = movies
  .collect { |movie| movie[:producer] }
  .uniq
  .sort_by { |producer| producer.split.last }

puts "\nList of producers:"
puts producers

foreign_movies = movies.count { |movie| movie[:country] != 'USA' }

puts "\nCount of non-USA movies - #{foreign_movies}"
