# coding: utf-8
# frozen_string_literal: true

require 'dotenv/load'
require 'progress_bar'
require 'themoviedb-api'
require 'yaml'

module Movies
  module Utils
    class TmdbParser
      def initialize
        Tmdb::Api.key(ENV['TMDB_API_KEY'])
        Tmdb::Api.language('ru')
      end

      def run(collection)
        bar = ProgressBar.new(collection.size, :bar, :counter, :eta)
        collection.each_with_object(Hash.new(0)) do |movie, info|
          tmdb_movie = Tmdb::Find.movie(movie.imdb_id, external_source: 'imdb_id').first
          bar.increment!

          info[movie.imdb_id] = {title: tmdb_movie.title, poster_path: tmdb_movie.poster_path}
        end
      end

      def save(data)
        File.write(Movies::MovieCollection::INFO_FILE, data.to_yaml)
      end
    end
  end
end
