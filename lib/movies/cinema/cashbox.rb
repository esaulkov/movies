# coding: utf-8
# frozen_string_literal: true

module Movies
  module Cinema
    module Cashbox
      def cash
        (@coins ||= Money.new(0)).format
      end

      def put_money(sum)
        @coins ||= Money.new(0)
        @coins += Money.new(sum * 100)
      end

      def take(who)
        unless who == 'Bank'
          raise ArgumentError, 'Оставайтесь на месте, наряд уже выехал!'
        end
        @coins = Money.new(0)
        'Проведена инкассация'
      end
    end
  end
end
