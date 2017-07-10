# coding: utf-8
# frozen_string_literal: true

require 'time'

module Movies
  class Theatre < Cinema
    SCHEDULE = {
      утром: {period: :ancient},
      днем: {genres: %w[Comedy Adventure]},
      вечером: {genres: %w[Drama Horror]}
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

    CINEMA_CLOSED_MSG = 'Кинотеатр закрыт, касса не работает'

    include Cashbox

    def initialize(collection)
      super
    end

    def buy_ticket(time)
      period = find_period(time)
      raise ArgumentError, CINEMA_CLOSED_MSG if period.nil?

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
      TIME_PERIODS.select do |_key, value|
        value.include?(Time.parse(time))
      end.keys.first
    end
  end
end
