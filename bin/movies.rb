#!/usr/bin/env ruby
# coding: utf-8

require_relative '../lib/database'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
DEFAULT_PATH = File.join(APP_ROOT, 'data/movies.txt').freeze
MIN_RATING = 8.freeze

def path_valid?(path)
  File.file?(path)
end

def show_rating(number)
  value = ((number - MIN_RATING) * 10).round
  '*' * value
end

movies_db = Database.new
search_name = ARGV[0]
movies_file = ARGV[1] || DEFAULT_PATH
abort("This file doesn't exist") unless path_valid?(movies_file)

movies_db.load(movies_file)

result = movies_db.search(search_name)
result.map do |movie|
  rating = movies_db.rating(movie)
  puts "#{movie} #{show_rating(rating)}"
end
