#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

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
  cinema = Movies::Cinema::Theatre.new(movies) do
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50

    period '09:00'..'11:00' do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :blue
    end

    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genre: %w[Action Drama], year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end
  end
  puts "\nNow is 10:40. What is the movie?"
  puts cinema.show('10:40')
  puts "\nAnd now is 17:00. What is the movie?"
  puts cinema.show('17:00')
  puts "\nI want to watch Guardians of the Galaxy. When could I do it?"
  puts cinema.when?('Guardians of the Galaxy')
  puts "\nPlease give me one ticket to the next show"
  puts cinema.buy_ticket('17:40')

  puts "\nOur online cinema Netflix presents:"
  cinema = Movies::Cinema::Netflix.new(movies)
  cinema.pay(30)
  puts cinema.show(genre: 'Comedy', period: :modern)
  puts "\nThe next movie is:"
  puts cinema.show(genre: 'Adventure', period: :new)
  puts "\nSome new action except Terminator? Of course!"
  puts cinema.show { |movie| !movie.name.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003 }
  puts "\nI like to watch new Sci-Fi movies. Save filter..."
  cinema.define_filter(:new_sci_fi) do |movie|
    movie.period == :new && movie.genre.include?('Sci-Fi')
  end
  puts "\nAnd apply it!"
  puts cinema.show(new_sci_fi: true)
  puts "\nAnd something else (new_sci_fi: false)"
  puts cinema.show(new_sci_fi: false)
  puts "\nLet's create a filter with params (Sci-Fi genre, before some year)..."
  cinema.define_filter(:ancient_sci_fi) do |movie, year|
    movie.year < year && movie.genre.include?('Sci-Fi')
  end
  puts "\nTry to apply (before 1941)..."
  puts cinema.show(ancient_sci_fi: 1941)
  puts "\nLet's create a child filter (year < 1980)"
  cinema.define_filter(:classic_sci_fi, from: :ancient_sci_fi, arg: 1980)
  puts "\nTry to apply it:"
  puts cinema.show(classic_sci_fi: true)
  puts "\nHow expensive is this movie (Batman Begins)?"
  puts cinema.how_much?('Batman Begins')
  puts "\nWell, how much is in cashbox?"
  puts Movies::Cinema::Netflix.cash
  puts "\nI'm from National Bank. Give me please these money."
  puts Movies::Cinema::Netflix.take('Bank')
  puts "\nI'm not from the bank. But I want these money too!"
  puts Movies::Cinema::Netflix.take('Jonny')
rescue ArgumentError => e
  puts '**********************************'
  puts e.message
  puts '**********************************'
end
