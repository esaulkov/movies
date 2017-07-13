# coding: utf-8
# frozen_string_literal: true

require 'date'

module Movies
  class Movie
    PARAMS = %i[
      link name year country release genres length
      rating producer actors collection
    ].freeze

    include Virtus.model

    attribute :link, String
    attribute :name, String
    attribute :year, Integer
    attribute :country, String
    attribute :release, String
    attribute :genres, String
    attribute :length, Integer
    attribute :rating, Float
    attribute :producer, String
    attribute :actors, String
    attribute :collection, Object

    def initialize(hsh = {})
      self.attributes = hsh.keep_if { |key, _| PARAMS.include?(key) }
    end

    def actors
      @actors.split(',')
    end

    def genre
      genres
    end

    def genres
      @genres.split(',')
    end

    def length
      @length.to_i
    end

    def matches?(key, value)
      exclusion = key.to_s.split('_').first == 'exclude'
      attribute = Array(public_send(key.to_s.split('_').last))

      res = Array(value).product(attribute).any? do |filter_val, attr_val|
        filter_val === attr_val
      end

      exclusion ^ res
    end

    def has_genre?(string)
      unless @collection.genres.include?(string)
        raise ArgumentError, "This genre (#{string}) does not exist"
      end
      genres.include?(string)
    end

    def inspect
      "#<Movie #{self}>"
    end

    def month
      return if release.size < 5
      Date.strptime(release, '%Y-%m').month
    end

    def period
      self.class.to_s.scan(/(\w+)Movie/).flatten.first.downcase.to_sym
    end

    def to_s
      "#{name} (#{release}; #{country}; #{@genres.to_s.tr(',', '/')})
       - #{length} min"
    end

    def self.create(params)
      case params[:year].to_i
      when 1900..1945 then AncientMovie.new(params)
      when 1946..1968 then ClassicMovie.new(params)
      when 1969..2000 then ModernMovie.new(params)
      when 2000..Date.today.year then NewMovie.new(params)
      else new(params)
      end
    end
  end
end
