# coding: utf-8
# frozen_string_literal: true

require 'time'

module Movies
  class Theatre < Cinema
    SCHEDULE = {
      утром: {period: :ancient},
      днем: {genres: ['Comedy', 'Adventure']},
      вечером: {genres: ['Drama', 'Horror']}
    }.freeze

    TIME_PERIODS = {
      утром: Time.parse('05:00')..Time.parse('10:59'),
      днем: Time.parse('11:00')..Time.parse('16:59'),
      вечером: Time.parse('17:00')..Time.parse('23:59')
    }.freeze

    PRICES = {
      утром: 3,
      днем: 5,
      вечером: 10
    }.freeze

    include Cashbox

    def initialize(collection)
      super
    end

    def buy_ticket(time)
      period = find_period(time)
      if period.nil?
        raise ArgumentError, 'Кинотеатр закрыт, касса не работает'
      end

      movie = choice(@collection.filter(SCHEDULE[period]))
      put_money(PRICES[period])
      "Вы купили билет на #{movie.name}"
    end

    def show(time)
      period = find_period(time)
      return 'Извините, ночью сеансов нет.' if period.nil?

      selection = @collection.filter(SCHEDULE[period])

      display(choice(selection))
    end

    def when?(name)
      periods = []
      movie = @collection.filter(name: name).first

      periods = SCHEDULE.select do |_, condition|
        @collection.filter(condition).include?(movie)
      end.keys

      if periods.empty?
        'этот фильм в нашем театре не транслируется'
      else
        periods.join(' или ')
      end
    end

    private

    def find_period(time)
      TIME_PERIODS.select { |key, value| value === Time.parse(time) }.keys.first
    end
  end
end
