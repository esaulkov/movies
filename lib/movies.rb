# coding: utf-8
# frozen_string_literal: true

require 'money'
require 'virtus'
require 'movies/movie'
require 'movies/movie_collection'
require 'movies/ancient_movie'
require 'movies/classic_movie'
require 'movies/modern_movie'
require 'movies/new_movie'
require 'movies/cinema'
require 'movies/utils/haml_presenter'
require 'movies/utils/imdb_parser'
require 'movies/utils/tmdb_parser'

I18n.enforce_available_locales = false
