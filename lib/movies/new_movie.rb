# coding: utf-8
# frozen_string_literal: true

module Movies
  class NewMovie < Movie
    def price
      Money.new(500)
    end

    def to_s
      "#{name} - новинка, вышло #{years_from_release}! (#{@genres})"
    end

    private

    def years_from_release
      years = Date.today.year - year.to_i
      case years
      when 0 then 'в этом году'
      when 1 then 'в прошлом году'
      when 2..4 then "#{years} года назад"
      else
        "#{years} лет назад"
      end
    end
  end
end
