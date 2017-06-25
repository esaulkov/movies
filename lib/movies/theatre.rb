# coding: utf-8
# frozen_string_literal: true

require 'time'

class Theatre
  def initialize(collection)
    @collection = collection
  end

  def show(time)
    selection =
      case Time.parse(time)
      when Time.parse('05:00')..Time.parse('10:59')
        @collection.filter(year: 1900..1945)
      when Time.parse('11:00')..Time.parse('16:59')
        (@collection.filter(genres: 'Comedy') + @collection.filter(genres: 'Adventure')).uniq
      when Time.parse('17:00')..Time.parse('23:59')
        (@collection.filter(genres: 'Drama') + @collection.filter(genres: 'Horror')).uniq
      else
        collection.all
      end
    "Now showing: #{selection.sample}"
  end

  def when?(name)
    periods = []
    movie = @collection.filter(name: name).first

    periods << 'утром' if movie.year < 1946
    if movie.has_genre?('Comedy') || movie.has_genre?('Adventure')
      periods << 'днем'
    end
    if movie.has_genre?('Drama') || movie.has_genre?('Horror')
      periods << 'вечером'
    end

    periods.join(' или ')
  end
end
