# coding: utf-8

class Movie
  GENRES = %w[
    Action Adventure Animation Biography Comedy Crime Drama Family Fantasy
    Film-Noir History Horror Music Musical Mystery Romance Sci-Fi Sport
    Thriller War Western
  ].freeze
  PARAMS = %i[link name year country release genres length rating producer actors].freeze
  attr_accessor *PARAMS

  def initialize(hsh = {})
    hsh
      .keep_if { |key, _| PARAMS.include?(key) }
      .each { |key, value| public_send("#{key}=", value) }
  end

  def actors_list
    actors.split(',')
  end

  def genres_list
    genres.split(',')
  end

  def has_genre?(string)
    unless GENRES.include?(string)
      raise ArgumentError, "This genre (#{string}) does not exist"
    end
    genres.include?(string)
  end

  def inspect
    "\n" + to_s
  end

  def to_s
    "#{name} (#{release}; #{country}; #{genres.gsub(/,/, '/')}) - #{length}"
  end
end
