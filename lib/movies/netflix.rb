# coding: utf-8
# frozen_string_literal: true

module Movies
  class Netflix < Cinema
    MONEY_MSG = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'
    NEGATIVE_VALUE_MSG = 'Нельзя пополнить баланс на отрицательную сумму'
    NOT_FOUND_MSG = 'Такой фильм не найден'

    extend Cashbox

    attr_reader :balance, :filters

    def initialize(collection)
      super
      @balance = Money.new(0)
      @filters = {}
    end

    def define_filter(name, from: nil, arg: nil, &block)
      return @filters[name] = block if from.nil?

      @filters[name] = ->(movie) { @filters[from].call(movie, arg) }
    end

    def show(params = {}, &block)
      block_filter = block_given? ? block : find_filter(params)
      selection = @collection.filter(params, &block_filter)
      movie = choice(selection)

      raise ArgumentError, MONEY_MSG if @balance < movie.price

      @balance -= movie.price
      display(movie)
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

    def find_filter(params)
      @filters.map do |key, value|
        case params[key]
        when TrueClass then value
        when Something then ->(movie) { value.call(movie, params[key]) }
        end
      end.compact.first
    end
  end

  class Something
    def self.===(item)
      [FalseClass, NilClass].none? { |wrong_class| item.is_a?(wrong_class) }
    end
  end
end
