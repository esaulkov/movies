#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib'))
require 'movies'

collection = Movies::MovieCollection.new
parser = Movies::Utils::ImdbParser.new
parser.run(collection)
parser.save
