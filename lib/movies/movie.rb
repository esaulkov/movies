# coding: utf-8
# frozen_string_literal: true

require 'date'
require 'yaml'

module Movies
  class ArrayOfStrings < Virtus::Attribute
    def coerce(value)
      value.nil? ? [] : value.split(',')
    end
  end

  class Movie
    BUDGETS_FILE = 'budgets.yml'
    INFO_FILE = 'info.yml'
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

    def length=(length_str)
      super length_str.to_i
    end

    def matches?(key, value)
      exclusion = key.to_s.split('_').first == 'exclude'
      attribute = Array(public_send(key.to_s.split('_').last))

      res = Array(value).product(attribute).any? do |filter_val, attr_val|
        filter_val === attr_val
      end

      exclusion ^ res
    end

    def budget
      raise ArgumentError, 'File not found!' unless File.exist?(BUDGETS_FILE)
      budgets = YAML.load_file(BUDGETS_FILE)
      budgets[imdb_id] || 'Unknown'
    end

    def has_genre?(string)
      unless @collection.genres.include?(string)
        raise ArgumentError, "This genre (#{string}) does not exist"
      end
      genres.include?(string)
    end

    def imdb_id
      link.scan(%r{title/([\w]*)/}).flatten.first
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

    def poster_path
      load_info[:poster_path]
    end

    def title_in_russian
      load_info[:title]
    end

    def to_s
      "#{name} (#{release}; #{country}; #{genres.join('/')})
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

    private

    def load_info
      raise ArgumentError, 'File not found!' unless File.exist?(INFO_FILE)
      f = YAML.load_file(INFO_FILE)
      f.select { |item| item.keys.first == imdb_id }.first.values.first
    end
  end
end
