# coding: utf-8
# frozen_string_literal: true

require 'date'

class Movie
  PARAMS = %i[
    link name year country release genres length
    rating producer actors collection
  ].freeze
  attr_reader :link, :name, :country, :release, :producer, :collection

  def initialize(hsh = {})
    hsh
      .keep_if { |key, _| PARAMS.include?(key) }
      .each { |key, value| instance_variable_set("@#{key}", value) }
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

  def matches?(key, value)
    attribute = public_send(key)
    if attribute.is_a?(Array)
      attribute.any? { |elem| value === elem }
    else
      value === attribute
    end
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

  def length
    @length.to_i
  end

  def month
    return if release.size < 5
    Date.strptime(release, '%Y-%m').month
  end

  def period
    class_name = self.class.to_s
    class_name.slice!('Movie')
    class_name.downcase.to_sym
  end

  def rating
    @rating.to_f
  end

  def to_s
    "#{name} (#{release}; #{country}; #{@genres.to_s.tr(',', '/')})
     - #{length} min"
  end

  def year
    @year.to_i
  end

  def self.create(params)
    case params[:year].to_i
    when 1900..1945 then AncientMovie.new(params)
    when 1946..1968 then ClassicMovie.new(params)
    when 1969..2000 then ModernMovie.new(params)
    when 2000..Date.today.year then NewMovie.new(params)
    else self.new(params)
    end
  end
end
