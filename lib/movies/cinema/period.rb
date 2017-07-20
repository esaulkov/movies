# coding: utf-8
# frozen_string_literal: true

module Movies
  module Cinema
    class Period
      attr_reader :cost, :filter, :halls, :interval, :name

      def initialize(interval, theatre, &block)
        @interval = Time.parse(interval.min)..Time.parse(interval.max)
        @theatre = theatre
        @halls = []
        instance_eval(&block) if block_given?
      end

      def tickets
        @halls.map(&:places).reduce(:+)
      end

      def to_s
        "#{@description}: "\
        "#{@interval.begin.strftime('%H:%M')} - #{@interval.end.strftime('%H:%M')},"\
        " #{@halls.map(&:title).join(', ')}"
      end

      private

      def description(str)
        @description = str
      end

      def filters(params)
        @filter = params
      end

      def hall(*names)
        @halls = names.map do |name|
          @theatre.halls.select { |hall| hall.name == name }.first ||
            raise(ArgumentError, "Нет такого зала (#{name}) в кинотеатре")
        end
      end

      def price(value)
        @cost = value
      end

      def title(str)
        @name = str
      end
    end
  end
end
