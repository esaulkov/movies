#!/usr/bin/env ruby
# coding: utf-8

require 'date'

DEFAULT_PATH = 'movies.txt'.freeze

def movies_list(films)
  films.map do |movie|
    "#{movie[:name]} (#{movie[:release]}; #{movie[:genres].gsub(/,/, '/')}) - #{movie[:length]}"
  end.join("\n")
end

search_name = ARGV[0]
movies_file = ARGV[1] || DEFAULT_PATH
abort("This file doesn't exist") unless File.file?(movies_file)

movies = []
keys = %i[link name year country release genres length rating producer actors]
db = File.new(movies_file, 'r')
db.each_line do |line|
  movie_params = line.split('|')
  movies << keys.zip(movie_params).to_h
end

sorted = movies.sort_by { |movie| movie[:length].to_i }.last(5).reverse

puts 'The five longest movies are:'
puts movies_list(sorted)

comedies = movies.select { |movie| movie[:genres].include?('Comedy') }

sorted = comedies.sort_by do |movie|
  if movie[:release].include?('-')
    Date.parse(movie[:release])
  else
    DateTime.new(movie[:release].to_i)
  end
end

puts "\nThe first ten comedies are:"
puts movies_list(sorted.first(10))

producers = movies.collect { |movie| movie[:producer] }.uniq
sorted = producers.sort_by { |producer| producer.split.last }

puts "\nList of producers:"
puts sorted

foreign_movies = movies.select { |movie| movie[:country] != 'USA' }

puts "\nCount of non-USA movies - #{foreign_movies.size}"
