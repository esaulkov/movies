# coding: utf-8
# frozen_string_literal: true

module Movies
  class Netflix < Cinema
    MONEY_MSG = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'
    NEGATIVE_VALUE_MSG = 'Нельзя пополнить баланс на отрицательную сумму'
    NOT_FOUND_MSG = 'Такой фильм не найден'

    extend Cashbox

    attr_reader :balance, :filters, :collection

    def initialize(collection)
      super
      @balance = Money.new(0)
      @filters = {}
    end

    def by_country
      CountrySelection.new(@collection)
    end

    def by_genre
      GenreSelection.new(@collection)
    end

    def define_filter(name, from: nil, arg: nil, &block)
      return @filters[name] = block if from.nil?

      @filters[name] = ->(movie) { @filters[from].call(movie, arg) }
    end

    def show(params = {}, &block)
      args = process_filters(params)
      args << block if block_given?
      selection = @collection.filter(args)
      movie = choice(selection)

      raise ArgumentError, MONEY_MSG if @balance < movie.price

      @balance -= movie.price
      display(movie)
    end

    def render
      output = HamlPresenter.new(self).show
      File.write('result.html', output)
    end

    def pay(sum)
      raise ArgumentError, NEGATIVE_VALUE_MSG if sum.negative?
      @balance += Money.new(sum * 100.0)
      Netflix.put_money(sum.to_f)
    end

    def how_much?(name)
      movie = @collection.filter(name: name).first
      raise ArgumentError, NOT_FOUND_MSG if movie.nil?
      movie.price.format
    end

    private

    def convert_filter(key, value)
      case value
      when true then @filters[key]
      when false then ->(movie) { !@filters[key].call(movie) }
      else ->(movie) { @filters[key].call(movie, value) }
      end
    end

    def process_filters(params)
      params.map do |key, value|
        @filters.key?(key) ? convert_filter(key, value) : {key => value}
      end
    end
  end
end
