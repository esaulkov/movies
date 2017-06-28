# coding: utf-8
# frozen_string_literal: true

class Netflix < Cinema
  MONEY_MSG = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'.freeze
  NEGATIVE_VALUE_MSG = 'Нельзя пополнить баланс на отрицательную сумму'.freeze
  NOT_FOUND_MSG = 'Такой фильм не найден'.freeze

  attr_reader :balance

  def initialize(collection)
    super
    @balance = 0.0
  end

  def show(params = {})
    selection = @collection.filter(params)
    movie = choice(selection)

    raise ArgumentError, MONEY_MSG if @balance < movie.price

    @balance -= movie.price
    display(movie)
  end

  def pay(sum)
    raise ArgumentError, NEGATIVE_VALUE_MSG if sum < 0
    @balance += sum.to_f
  end

  def how_much?(name)
    movie = @collection.filter(name: name).first
    raise ArgumentError, NOT_FOUND_MSG if movie.nil?
    movie.price
  end
end
