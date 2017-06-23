#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH.unshift(File.expand_path('../lib', 'lib'))
require 'movies'

movies = MovieCollection.new(ARGV[0])

begin
  puts 'The last five movies in collection:'
  puts movies.all.last(5)

  puts "\nList of actors in the first movie:"
  puts movies.all.first.actors

  puts "\nThe five longest movies are:"
  puts movies.sort_by(:length).reverse.first(5)

  puts "\nList of british comedies:"
  puts movies.filter(genres: 'Comedy', country: 'UK')

  puts "\nStats by producer:"
  puts movies.stats(:producer)

  puts "\nStats by country:"
  puts movies.stats(:country)

  puts "\nStats by genre:"
  puts movies.stats(:genres)

  puts "\nStats by year:"
  puts movies.stats(:year)

  puts "\nStats by month:"
  puts movies.stats(:month)

  puts "\nTesting exception:"
  movies.all.first.has_genre?('Jazz')
rescue ArgumentError => e
  puts '**********************************'
  puts e.message
  puts '**********************************'
end
