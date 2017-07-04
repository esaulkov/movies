# coding: utf-8
# frozen_string_literal: true

module Movies
  class Netflix < Cinema
    MONEY_MSG = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'
    NEGATIVE_VALUE_MSG = 'Нельзя пополнить баланс на отрицательную сумму'
    NOT_FOUND_MSG = 'Такой фильм не найден'

    extend Cashbox

    attr_reader :balance

    def initialize(collection)
      super
      @balance = Money.new(0)
    end

    def show(params = {})
      selection = @collection.filter(params)
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
  end
end
