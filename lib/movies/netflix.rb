# coding: utf-8
# frozen_string_literal: true

class Netflix < Cinema
  MONEY_MSG = 'Не хватает денег для просмотра, пополните, пожалуйста, баланс.'.freeze

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
    translate(movie)
  end

  def pay(sum)
    if sum.to_f > 0
      @balance += sum.to_f
    end
  end

  def how_much?(name)
    movie = @collection.filter(name: name).first
    movie.nil? ? 0 : movie.price
  end
end
