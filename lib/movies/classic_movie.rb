# coding: utf-8
# frozen_string_literal: true

require_relative 'movie'

class ClassicMovie < Movie
  def to_s
    "#{name} - классический фильм, режиссер #{producer} (#{@genres})"
  end
end
