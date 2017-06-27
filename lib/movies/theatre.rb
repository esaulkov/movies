# coding: utf-8
# frozen_string_literal: true

require 'time'

class Theatre < Cinema
  SCHEDULE = {
    morning: {period: :ancient},
    day: {genres: ['Comedy', 'Adventure']},
    evening: {genres: ['Drama', 'Horror']}
  }.freeze

  TIME_PERIODS = {
    morning: Time.parse('05:00')..Time.parse('10:59'),
    day: Time.parse('11:00')..Time.parse('16:59'),
    evening: Time.parse('17:00')..Time.parse('23:59')
  }.freeze

  def initialize(collection)
    super
  end

  def show(time)
    period = TIME_PERIODS.select { |key, value| value === Time.parse(time) }.keys.first
    return 'Извините, ночью сеансов нет.' if period.nil?

    selection = SCHEDULE[period].flat_map do |key, value|
      if value.is_a?(Array)
        value.flat_map { |item| @collection.filter(Hash[key, item]) }
      else
        @collection.filter(Hash[key, value])
      end
    end.uniq

    translate(choice(selection))
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

    if periods.empty?
      'этот фильм в нашем театре не транслируется'
    else
      periods.join(' или ')
    end
  end
end
