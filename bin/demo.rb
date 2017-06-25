#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH.unshift(File.expand_path('../lib', 'lib'))
require 'movies'

movies = MovieCollection.new(ARGV[0])

begin
  puts "\nList of actors in the first movie:"
  puts movies.all.first.actors

  puts "\nThe five longest movies are:"
  puts movies.sort_by(:length).reverse.first(5)

  puts "\nList of british comedies:"
  puts movies.filter(genres: 'Comedy', country: 'UK')

  puts "\nStats by producer:"
  puts movies.stats(:producer)

  puts "\nStats by genre:"
  puts movies.stats(:genres)

  puts "\nStats by month:"
  puts movies.stats(:month)

  puts "\nLet's go to cinema..."
  cinema = Theatre.new(movies)
  puts "\nNow is 10:40. What is the movie?"
  puts cinema.show('10:40')
  puts "\nAnd now is 14:47. What is the movie?"
  puts cinema.show('14:47')
  puts "\nI want to watch Metropolis. When I could to do it?"
  puts cinema.when?('Metropolis')

  puts "\nOur online cinema Netflix presents:"
  cinema = Netflix.new(movies)
  cinema.pay(10)
  puts cinema.show(genre: 'Comedy', period: :modern)
  puts "\nThe next movie is:"
  puts cinema.show(genre: 'Adventure', period: :new)
  puts "\nAnd one more movie..."
  puts cinema.show(name: 'Batman Begins')
  puts "\nHow expensive is this movie?"
  puts cinema.how_much?('Batman Begins')
  puts "\nLet's pay for it"

rescue ArgumentError => e
  puts '**********************************'
  puts e.message
  puts '**********************************'
end
