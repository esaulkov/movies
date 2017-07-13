# coding: utf-8
# frozen_string_literal: true

module Movies
  class Show
    attr_reader :halls, :period, :filter, :name, :cost

    def initialize(period, theatre, &block)
      @period = Time.parse(period.min)..Time.parse(period.max)
      @theatre = theatre
      @halls = []
      instance_eval(&block) if block_given?
    end

    def tickets
      @halls.map(&:places).reduce(:+)
    end

    def to_s
      "#{@description}: "\
      "#{@period.begin.strftime('%H:%M')} - #{@period.end.strftime('%H:%M')},"\
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
      @halls = @theatre.halls.select { |hall| names.include?(hall.name) }
    end

    def price(value)
      @cost = value
    end

    def title(str)
      @name = str
    end
  end
end
