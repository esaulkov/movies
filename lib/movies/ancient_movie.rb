# coding: utf-8
# frozen_string_literal: true

require_relative 'movie'

class AncientMovie < Movie
  def to_s
    "#{name} - старый фильм (#{year} год), жанры: #{@genres}"
  end
end
