# coding: utf-8
# frozen_string_literal: true

module Cashbox
  def cash
    @coins ||= 0
  end

  def put_money(sum)
    @coins ||= 0
    @coins += sum
  end

  def take(who)
    raise ArgumentError, 'Оставайтесь на месте, наряд уже выехал!' unless who == 'Bank'
    @coins = 0
    'Проведена инкассация'
  end
end
