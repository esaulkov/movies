# coding: utf-8
# frozen_string_literal: true

module Movies
  class ModernMovie < Movie
    def price
      Money.new(300)
    end

    def to_s
      "#{name} - современное кино (#{genres.join(', ')}), играют #{actors.join(', ')}"
    end
  end
end
