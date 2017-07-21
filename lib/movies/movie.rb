# coding: utf-8
# frozen_string_literal: true

require 'date'

# Namespace for classes and modules that work with movie collection and its members
module Movies
  # Class for Movie attributes.
  # Defines array of strings and has used for actors list or genres list
  class ArrayOfStrings < Virtus::Attribute
    # Overrides default behaviour for this method. Splits source string using ',' as delimiter
    # @param [String] value source string
    # @return [Array] array of strings or blank array
    def coerce(value)
      value.nil? ? [] : value.split(',')
    end
  end

  # Base class for work with movies
  # @attr [String] link link to IMDB page for the movie
  # @attr [String] name movie name in English
  # @attr [Integer] year release year for the movie
  # @attr [String] country movie country
  # @attr [String] release release date for the movie
  # @attr [ArrayOfStrings] genres list of genres
  # @attr [Integer] length movie length (in minutes)
  # @attr [Float] rating movie rating
  # @attr [String] producer movie producer name
  # @attr [ArrayOfStrings] actors list of actors
  # @attr [Object] collection movie collection that movie includes
  class Movie
    # list of movie attributes. Used for parsing source text file.
    PARAMS = %i[
      link name year country release genres length
      rating producer actors
    ].freeze

    include Virtus.model

    attribute :link, String
    attribute :name, String
    attribute :year, Integer
    attribute :country, String
    attribute :release, String
    attribute :genres, ArrayOfStrings
    attribute :length, Integer
    attribute :rating, Float
    attribute :producer, String
    attribute :actors, ArrayOfStrings
    attribute :collection, Object

    alias genre genres

    # Setter for length attribute. Converts string like '152 min' to number like '152'.
    # @param [String] length_str source string
    # @return [Integer]
    def length=(length_str)
      super length_str.to_i
    end

    # Checks if movie attribute matches given value
    # @param [Symbol] key name of movie attribute
    # @param [String, Integer, Array, Set] value for checking
    #
    # @example check string attribute
    #   movie.matches?(:producer, 'Peter Jackson') => true
    # @example check year
    #   movie.matches?(:year, 1961..1980) => true
    # @example check genre or actor
    #   movie.matches?(:genres, 'Sci-Fi') => false
    # @example negate matching
    #   movie.matches?(:exclude_genre, 'Action') => true
    #
    # @return [Boolean] true or false
    def matches?(key, value)
      exclusion = key.to_s.split('_').first == 'exclude'
      attribute = Array(public_send(key.to_s.split('_').last))

      res = Array(value).product(attribute).any? do |filter_val, attr_val|
        filter_val === attr_val
      end

      exclusion ^ res
    end

    # Returns movie budget
    # @return [String] when movie budget is absent in database returns 'Unknown' string
    def budget
      @collection.budgets[imdb_id] || 'Unknown'
    end

    # Checks if the movie belongs to the given genre
    # @param [String] string String with genre name
    #
    # @raise [ArgumentError] when there are no movies with this genre in the collection
    #
    # @return [Boolean] true or false
    def has_genre?(string)
      unless @collection.genres.include?(string)
        raise ArgumentError, "This genre (#{string}) does not exist"
      end
      genres.include?(string)
    end

    # Selects IMDB ID from the movie link
    # @return [String] IMDB id like 'tt0068646'
    def imdb_id
      link.scan(%r{title/([\w]*)/}).flatten.first
    end

    # Overrides default method
    # @return [String]
    def inspect
      "#<Movie #{self}>"
    end

    # Month of the movie release
    # @return [Fixnum] number of movie month or nil, if release size is lesser than 5 symbols
    def month
      return if release.size < 5
      Date.strptime(release, '%Y-%m').month
    end

    # Period of movie (ancient, classic, modern or new)
    # @return [Symbol]
    def period
      self.class.to_s.scan(/(\w+)Movie/).flatten.first.downcase.to_sym
    end

    # Path to poster at themoviedb.org. Used for render HTML page.
    # @return [String]
    def poster_path
      additional_info[:poster_path]
    end

    # Movie title in russian language
    # @return [String]
    def title_in_russian
      additional_info[:title]
    end

    # Overrides default method. Shows movie name, release date, country, genres and length
    # @return [String]
    def to_s
      "#{name} (#{release}; #{country}; #{genres.join('/')})
       - #{length} min"
    end

    # Base method to select proper class of movie. It depends on release year.
    # @param [Hash] params movie params
    #
    # @return [Movie] created object
    def self.create(params)
      case params[:year].to_i
      when 1900..1945 then AncientMovie.new(params)
      when 1946..1968 then ClassicMovie.new(params)
      when 1969..2000 then ModernMovie.new(params)
      when 2000..Date.today.year then NewMovie.new(params)
      else new(params)
      end
    end

    private

    # Gets additional params for the movie from collection.
    # Saves this value to use in the future.
    # @private
    #
    # @return [Hash]
    def additional_info
      @additional_info ||= @collection.additional_info[imdb_id]
    end
  end
end
