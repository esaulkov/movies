#!/usr/bin/env ruby
# coding: utf-8

DEFAULT_PATH = 'movies.txt'.freeze
MIN_RATING = 8
NAME_INDEX = 1
RATING_INDEX = 7

search_name = ARGV[0]
movies_file = ARGV[1] || DEFAULT_PATH
abort("This file doesn't exist") unless File.file?(movies_file)

search_result = []
db = File.new(movies_file, 'r')
db.each_line do |line|
  movie_params = line.split('|')
  if movie_params[NAME_INDEX].include?(search_name)
    search_result << {name: movie_params[NAME_INDEX],
                      rating: movie_params[RATING_INDEX].to_f}
  end
end

search_result.map do |movie|
  rating = '*' * ((movie[:rating] - MIN_RATING) * 10).round
  puts "#{movie[:name]} #{rating}"
end
