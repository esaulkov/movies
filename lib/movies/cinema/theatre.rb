# coding: utf-8
# frozen_string_literal: true

require 'time'

module Movies
  module Cinema
    class Theatre < Cinema
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

      def buy_ticket(time, hall_name = nil)
        period = find_period(time, hall_name)
        raise ArgumentError, CINEMA_CLOSED_MSG if period.nil?

        movie = find_movie(period)
        hall = find_hall(period, hall_name)
        put_money(period.cost)
        "Вы купили билет на #{movie.name} в #{hall.title}"
      end

      def show(time, hall_name = nil)
        period = find_period(time, hall_name)
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
        begin1 = first.interval.begin
        end1 = first.interval.end
        begin2 = second.interval.begin
        end2 = second.interval.end
        same_hall?(first, second) && end1 > begin2 && begin1 < end2
      end

      def find_hall(period, hall_name)
        if hall_name.nil?
          period.halls.sort_by { |h| h.places * rand }.last
        else
          period.halls.select { |h| h.name == hall_name }.last
        end
      end

      def find_movie(period)
        choice(selection(period))
      end

      def find_period(time, hall_name)
        selection = @periods.select do |period|
          period.interval.include?(Time.parse(time)) &&
            (hall_name.nil? || period.halls.map(&:name).include?(hall_name))
        end
        raise ArgumentError, many_periods_msg(selection) if selection.size > 1
        selection.first
      end

      def hall(hall_name, params)
        @halls << Hall.new(hall_name, params)
      end

      def many_periods_msg(selection)
        halls = selection
                .flat_map { |period| period.halls.map(&:name) }
                .uniq
                .join(', ')
        "В это время проходят несколько сеансов. Укажите зал (#{halls}) при покупке билета"
      end

      def period(interval, &block)
        @periods << Period.new(interval, self, &block)
      end

      def same_hall?(first, second)
        (first.halls & second.halls).any?
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
end
