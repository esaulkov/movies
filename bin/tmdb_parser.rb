#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib'))
require 'movies'

collection = Movies::MovieCollection.new
parser = Movies::Utils::TmdbParser.new
data = parser.run(collection)
parser.save(data)
