# coding: utf-8
# frozen_string_literal: true

class ModernMovie < Movie
  def price
    3
  end

  def to_s
    "#{name} - современное кино (#{@genres}), играют #{@actors}"
  end
end
