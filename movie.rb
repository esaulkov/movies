# coding: utf-8

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

  def genres
    @genres.split(',')
  end

  def has_attr?(key, value)
    attr = public_send(key)
    if attr.is_a?(Array)
      if value.is_a?(Regexp)
        attr.select { |attribute| attribute[value] }.any?
      else
        attr.include?(value)
      end
    elsif value.is_a?(Range)
      value.include?(attr)
    else
      attr === value
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

  def rating
    @rating.to_f
  end

  def to_s
    "#{name} (#{release}; #{country}; #{@genres.tr(/,/, '/')}) - #{length} min"
  end

  def year
    @year.to_i
  end
end
