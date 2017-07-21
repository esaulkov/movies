#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib'))
require 'movies'
require 'slop'

opts = Slop.parse do |o|
  o.int '--pay', 'sum to pay'
  o.string '--show', 'show movie', default: ''
  o.on '--help' do
    puts o
    exit
  end
end

collection = Movies::MovieCollection.new
cinema = Movies::Cinema::Netflix.new(collection)

cinema.pay(opts[:pay]) unless opts[:pay].nil?

params = {}
opts[:show].split(',').map do |param_string|
  key, value = param_string.split(':')
  params[key] = value
end

puts cinema.show(params)
