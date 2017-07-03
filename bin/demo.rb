#!/usr/bin/env ruby
# coding: utf-8

$LOAD_PATH.unshift(File.expand_path('../lib', 'lib'))
require 'movies'

movies = Movies::MovieCollection.new(ARGV[0])

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
  cinema = Movies::Theatre.new(movies)
  puts "\nNow is 10:40. What is the movie?"
  puts cinema.show('10:40')
  puts "\nAnd now is 14:47. What is the movie?"
  puts cinema.show('14:47')
  puts "\nI want to watch Metropolis. When I could to do it?"
  puts cinema.when?('Metropolis')
  puts "\nPlease give me one ticket to the next show"
  puts cinema.buy_ticket('20:00')

  puts "\nOur online cinema Netflix presents:"
  cinema = Movies::Netflix.new(movies)
  cinema.pay(10)
  puts cinema.show(genre: 'Comedy', period: :modern)
  puts "\nThe next movie is:"
  puts cinema.show(genre: 'Adventure', period: :new)
  puts "\nHow expensive is this movie (Batman Begins)?"
  puts cinema.how_much?('Batman Begins')
  puts "\nWell, how much is in cashbox?"
  puts Movies::Netflix.cash
  puts "\nI'm from National Bank. Give me please these money."
  puts Movies::Netflix.take('Bank')
  puts "\nI'm not from the bank. But I want these money too!"
  puts Movies::Netflix.take('Jonny')

rescue ArgumentError => e
  puts '**********************************'
  puts e.message
  puts '**********************************'
end
