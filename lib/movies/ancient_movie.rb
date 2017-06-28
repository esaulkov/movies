# coding: utf-8
# frozen_string_literal: true

class AncientMovie < Movie
  def price
    1
  end

  def to_s
    "#{name} - старый фильм (#{year} год), жанры: #{@genres}"
  end
end
