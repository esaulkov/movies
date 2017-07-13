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
    SCHEDULE_INVALID_MSG = 'Расписание некорректно (сеансы не должны пересекаться в одном зале)'

    include Cashbox

    attr_reader :halls, :periods

    def initialize(collection, &block)
      super
      @halls = []
      @periods = []
      instance_eval(&block) if block_given?
      raise ArgumentError, SCHEDULE_INVALID_MSG unless schedule_valid?
    end

    def buy_ticket(time)
      period = find_period(time)
      raise ArgumentError, CINEMA_CLOSED_MSG if period.nil?

      movie = find_movie(period)
      hall = period.halls.sort_by { |h| h.places * rand }.last
      put_money(period.cost)
      "Вы купили билет на #{movie.name} в #{hall.title}"
    end

    def show(time)
      period = find_period(time)
      return CINEMA_CLOSED_MSG if period.nil?

      movie = find_movie(period)
      display(movie)
    end

    def when?(name)
      movie = @collection.filter(name: name).first

      periods = @periods.select do |period|
        selection(period).include?(movie)
      end

      if periods.empty?
        'этот фильм в нашем театре не транслируется'
      else
        periods.map(&:to_s).join(' или ')
      end
    end

    private

    def cross?(first, second)
      begin1 = first.period.begin
      end1 = first.period.end
      begin2 = second.period.begin
      end2 = second.period.end
      same_hall?(first, second) && end1 > begin2 && begin1 < end2
    end

    def find_movie(period)
      choice(selection(period))
    end

    def find_period(time)
      @periods
        .select { |show| show.period.include?(Time.parse(time)) }
        .sort_by { |show| show.tickets * rand }
        .last
    end

    def hall(hall_name, params)
      @halls << Hall.new(hall_name, params)
    end

    def period(interval, &block)
      @periods << Show.new(interval, self, &block)
    end

    def same_hall?(first, second)
      (first.halls - second.halls).size < first.halls.size
    end

    def schedule_valid?
      return true if @periods.empty?
      @periods.combination(2).none? { |a, b| cross?(a, b) }
    end

    def selection(period)
      @collection.filter(period.name.nil? ? period.filter : {name: period.name})
    end
  end
end
